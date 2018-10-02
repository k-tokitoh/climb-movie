class PostsController < ApplicationController
    
    def index
        if session[:admin]                                                      #管理ユーザの場合、
            @posts = Post.where(approved: 'undecided').page(params[:page]).per(12)                       #undecidedのみをフィードして、
            @posts_num 
        else                                                                    #一般ユーザの場合、
            @posts = Post.where(approved: 'OK').page(params[:page]).per(12)     #公開が許可されたポストのみをフィードする
            @posts_num
        end
        gon.names = get_words_for_refine_search()
    end
    
    def update                                  #承認状況等の更新
        @post = Post.find(params[:id])
        @post.update_attributes(post_params)    #post_paramsはprivateで定義している
        render plain: @post.approved            # @postの承認状況(を表すテキスト)を送る
    end

    def get_youtube_videos
        #以下の３行、ここに書くのでよいのかな？
        require 'google/apis/youtube_v3'
        youtube = Google::Apis::YoutubeV3::YouTubeService.new       
        youtube.key = ENV["YOUTUBE_API_KEY"]     #'.env'ファイルで定義
        
        @problems = Problem.all
        @problems.each do |problem|
        
            results = youtube.list_searches(
                "id, snippet",                   #取得内容
                type: "video",          #チャンネルやプレイリストを含まず、動画のみ取得する
                q: problem.name,        #検索キーワードの指定（検索方法は他にも色々あり）
                max_results: 10        #最大取得件数
            ).items                     #動画リソースのみにフィルター
            
            results.each do |result|
                trimmed_title = trim(result.snippet.title)
                matched_post = Post.find_by(video: result.id.video_id)
                #既に動画を持っている場合、video_id以外の属性を更新する
                if matched_post.present?
                    matched_post.update(title: trimmed_title)
                else
                    matched_post = Problem.find_by(name: problem.name).posts.create(video: result.id.video_id, title: trimmed_title, approved: 'undecided')
                end
                
                # youtubeでのタイトルがエリア名、課題名、グレードを全て含む場合、そのpostの公開を許可する。
                # グレードは表記ゆれに対応し、いずれかを含めばよい。（定数はenvironment.rbで定義）
                perfect_match = true
                matched_post.problems.each do |problem|
                    if [problem.rock.area.name, problem.name, ].all?{|i|trimmed_title.include?(i)} == false \
                        || [GRADE_CORRESPONDENCE.to_h.invert[problem.grade], GRADE_QDver[problem.grade], GRADE_chara[problem.grade]].any?{|i|trimmed_title.include?(i)} == false
                        perfect_match = false
                    end
                end

                if perfect_match == true
                    matched_post.update(approved: 'OK')
                end
            end
        end
        
        redirect_to '/'
    end
    
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
            'areas.name as area, ' +                # 今回は全て名付け直しておいた。
            'rocks.name as rock, ' +
            'problems.name as problem, ' +
            'problems.grade as grade, ' +
            'posts.id as post_id'
        db = Region.joins(areas: {rocks: {problems: :posts}})       # 順次joinする
                    .where(posts: {approved: approval_condition})   # approval_conditonにマッチするpostのみ取り出す
                    .select(selection_string)                       # 検索に用いるカラムを取り出す

        if params.has_key?(:q)                              #フリーワード検索の時
            q = params[:q].gsub(/\p{blank}/,' ').split()    #検索クエリの全角スペースを半角スペースに置換してsplit
            #各レコードについて、複数の検索条件全てに合致するかをしらべて
            matched_ids = db.select{ |record| freeword_search(record, q)          # qは検索クエリワードの配列
            #すべての検索条件に合致する場合のみpost_idを記録する
            }.map{ |record| record.post_id}
        elsif [:region, :area, :problem, :grade].all?{ |condition| params.has_key?(condition)}   # 詳細検索の時
            db = db.select{ |record|
                [:region, :area, :problem].all?{ |condition|
                    params[condition] == '' || record[condition] == params[condition]    # paramsで空白の時は検査しない
                }
            }.select{ |record|
                    params[:grade][:lower].to_i <= record.grade  && record.grade <= params[:grade][:upper].to_i
            }
            matched_ids = db.map{ |record| record.post_id}
        end

        

        @posts = Post.where(id: matched_ids).page(params[:page]).per(12)    # 選択されたidのみ表示する
        @posts_num = Post.where(approved: 'OK').length
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
    
    def trim(text)      #mysqlが絵文字に対応していないため
      return text if text.nil?
      text.each_char do |b|
        text.delete!(b) if b.bytesize == 4
      end
      # 全角数字を半角にする
      text.tr!("０-９", "0-9")
      # 半角及び全角のスペースを取り除く
      text.gsub!(/(\s|　)+/, '')
      return text
    end
end
