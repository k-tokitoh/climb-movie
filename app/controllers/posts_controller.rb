class PostsController < ApplicationController

  # トップ画面の表示
  def index
    # いくつかテーブルをくっつけてよみこみ
    records = Area.joins(rocks: {problems: :posts}).select('areas.id, posts.video, posts.approved,posts.id as post_id, problems.id as problem_id')

    if session[:admin]
      posts = Post.where(approved: 'undecided').order(hit: :DESC)
      @posts = posts.page(params[:page]).per(12)                       #undecidedのみをフィードして、
      @posts_num = posts.size
    else
      # 公開が許可されているポストに限定する
      records = records.where(posts: {approved: 'OK'}).order('posts.hit DESC')

      # 1つの課題につき1つの動画を抽出する
      post_ids = records.group_by{|record|record.problem_id}.values.map{|r|r[0].post_id}
      # idによりレコードをとってきなおすとき、id順になってしまうようなので、再びhit順にする
      posts = Post.where(id: post_ids).order(hit: :DESC)
      @posts = posts.page(params[:page]).per(12)
      @posts_num = posts.size
      @feed_mode = '1_problem_1_movie'
    end

    # {:課題のid => その課題に紐づいた動画の数} というハッシュをつくっておく
    @posts_num_by_problem = records.group_by{|record| record.problem_id}.map{|k,v| [k,v.size]}.to_h

    # gon.names = get_words_for_refine_search()

  end

  #承認状況等の更新
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(post_params)    #post_paramsはprivateで定義している
    render plain: @post.approved            # @postの承認状況(を表すテキスト)を送る
  end

  # 再生回数のインクリメント
  def increment_hits
    hit = Post.find(params[:post_id]).hit
    hit += 1
    Post.find(params[:post_id]).update(hit: hit)
    render plain: hit
  end

  def create
    Post.create_from_youtube
    redirect_to '/'
  end

  # 検索
  def search
    if session[:admin]
      if params.has_key?(:approval)           # 検索条件の認証状態チェックボックスに一つでもチェックがある場合
        approval_condition = params[:approval].keys.map{|key|key.to_s}
      else
        approval_condition = ['OK', 'NG', 'undecided']
      end
    else
      approval_condition = ['OK']
    end
    #ex. params[:approval] = {"OK"=>"true", "NG"=>"true"}
    #ex. approval_condition = ["OK", "NG"]

    #検索対象となる情報をすべて含むactiverecord relationを取得する
    selection_string =                          # joinした後のActiveRecord_Relationでselectするときは、
      'regions.name as region, '+             # カラム名(nameとか)が重複するときは、asで名付け直さないといけないらしい
      'areas.id as area_id, ' +
      'areas.name as area, ' +                # 今回は全て名付け直しておいた。
      'rocks.name as rock, ' +
      'problems.id as problem_id, ' +
      'problems.name as problem, ' +
      'problems.grade as grade, ' +
      'posts.id as post_id'

    db = Region.joins(areas: {rocks: {problems: :posts}}).select(selection_string).order("posts.hit DESC")
    # この時点でdbはactiverecord relation(ハッシュを要素とする配列みたいなもの)

    # 承認状況で検索
    db = db.where(posts: {approved: approval_condition})

    # キー：エリアのid、値：そのエリアに紐づいた動画の数　というハッシュをつくっておく
    @posts_num_by_area = db.group_by{|record| record.area_id}.map{|k,v| [k,v.size]}.to_h

    # キー：課題のid、値：その課題に紐づいた動画の数　というハッシュをつくっておく
    @posts_num_by_problem = db.group_by{|record| record.problem_id}.map{|k,v| [k,v.size]}.to_h

    #フリーワード検索
    if params.has_key?(:q)
      q = params[:q].gsub(/\p{blank}/,' ').split()    #検索クエリの全角スペースを半角スペースに置換してsplit
      # 各レコードについて、複数の検索条件全てに合致するかをしらべて
      # select文を適用することで、dbはactiverecord relationからarrayになる
      db = db.select { |record| freeword_search(record, q) }          # qは検索クエリワードの配列
      #すべての検索条件に合致する場合のみpost_idを記録する
    end

    # 課題指定で検索
    if params.has_key?(:problem_ids)
      # 複数の課題が指定されている場合は、それらの課題のうちどれかに該当する動画を返すようにしたい（未実装）
      db = db.select{ |record| params[:problem_ids].include?(record.problem_id.to_s) }

      # db = db.select{ |record| record.problem_id == params[:problem_id].to_i }
      @feed_mode = '1_problem_many_movies'
      @problem = Problem.find(params[:problem_ids][0])
      @area = @problem.rock.area
    end

    # エリア指定で検索
    if params.has_key?(:area_id)
      # selectで指定されたエリアの課題を抽出する
      # group_by以下で１つの課題に対して、一番うえにある動画レコードのみを抽出する
      db = db.select{ |record| record.area_id == params[:area_id].to_i }.group_by{|record| record.problem_id}.values.map{|records| records[0]}
      @feed_mode = '1_problem_1_movie'
      @area = Area.find(params[:area_id])
    end

    matched_ids = db.map{ |record| record.post_id}
    # idによりレコードをとってきなおすとき、id順になってしまうようなので、再びhit順にする
    posts = Post.where(id: matched_ids).order(hit: :DESC)
    @region = Region.all
    @posts = posts.page(params[:page]).per(12)    # 選択されたidのみ表示する
    @posts_num = posts.size
    gon.names = get_words_for_refine_search()
    render 'index'
  end

  private

  def post_params
    params.require(:post).permit(:approved)
  end

  def freeword_search(record, query_words)
    words = [record.region, record.area, record.rock, record.problem]
    match_or_not =
      query_words.all?{ |qword|             # クエリをsplitして得られた各単語qwordに対して
        words.any?{ |word|              # そのqwordが単語リストwordsに
          word.include?(qword)        # 部分文字列として登場するか
        }                               # 1回でも登場したらtrueを返す
      }
    return match_or_not
  end

  def get_words_for_refine_search()
    names = {}
    names['region'] = Region.all.pluck('name')
    names['area'] = Region.joins(:areas).pluck('regions.name', 'areas.name')
    names['problem'] = Area.joins(rocks: :problems).pluck('areas.name', 'problems.name')
    names
  end
end
