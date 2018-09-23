class PostsController < ApplicationController
    
    def index
        if session[:admin]                                                      #管理ユーザの場合、
            @posts = Post.all.page(params[:page]).per(12)                       #全てのポストをフィードして、
        else                                                                    #一般ユーザの場合、
            @posts = Post.where(approved: 'OK').page(params[:page]).per(12)     #公開が許可されたポストのみをフィードする
        end
        @posts_num = Post.where(approved: 'OK').length
        gon.names = get_hash(Region.joins(areas: {rocks: :problems}).pluck('regions.name', 'areas.name', 'problems.name'))
        
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
                "id",                   #取得内容
                type: "video",          #チャンネルやプレイリストを含まず、動画のみ取得する
                q: problem.name,        #検索キーワードの指定（検索方法は他にも色々あり）
                max_results: 50        #最大取得件数
            ).items                     #動画リソースのみにフィルター
            
            results.each do |result|
                Problem.find_by(name: problem.name).posts.create(video: result.id.video_id, approved: 'undecided')
            end
        end
        
        redirect_to '/'
    end
    
    def search
       if session[:admin]
           if params.has_key?(:approval)           # 検索条件の認証状態チェックボックスに一つでもチェックがある場合
               approval_condition = params[:approval].keys.map{|key|key.to_s}
           else
               approval_condition = []
           end
       else
           approval_condition = ['OK']
       end
        #ex. params[:approval] = {"OK"=>"true", "NG"=>"true"}
        #ex. approval_condition = ["OK", "NG"]

        #検索対象となる情報をすべて含むactiverecord associationを取得する
        selection_string =                          # joinした後のActiveRecord_Relationでselectするときは、
            'regions.name as region, '+             # カラム名(nameとか)が重複するときは、asで名付け直さないといけないらしい
            'areas.name as area, ' +                # 今回は全て名付け直しておいた。
            'rocks.name as rock, ' +
            'problems.name as problem, ' +
            'posts.id as post_id'
        db = Region.joins(areas: {rocks: {problems: :posts}})       # 順次joinする
                    .where(posts: {approved: approval_condition})   # approval_conditonにマッチするpostのみ取り出す
                    .where(problems: {grade: params[:grade][:lower].to_i..params[:grade][:upper].to_i})
                    .select(selection_string)                       # 検索に用いるカラムを取り出す
        if params[:'地域'] != ''
            db = db.select{|record| record.region == params[:'地域']}
        end
        if params[:'岩場'] != ''
            db = db.select{|record| record.area == params[:'岩場']}
        end
        if params[:'課題'] != ''
            db = db.select{|record| record.problem == params[:'課題']}
        end
                    
        q = params[:q].gsub(/\p{blank}/,' ').split()    #検索クエリの全角スペースを半角スペースに置換してsplit

        matched_ids =
            #各レコードについて、複数の検索条件全てに合致するかをしらべて
            db.select{ |record| freeword_search(record, q)          # qは検索クエリワードの配列
            #すべての検索条件に合致する場合のみpost_idを記録する
            }.map{ |record| record.post_id}

        @posts = Post.where(id: matched_ids).page(params[:page]).per(12)    # 選択されたidのみ表示する
        @posts_num = Post.where(approved: 'OK').length
        gon.names = get_hash(Region.joins(areas: {rocks: :problems}).pluck('regions.name', 'areas.name', 'problems.name'))
        render 'index'
    end
    
    def set_refine_search
        if params[:id] == 'region'
            render partial: 'refine_search_card', locals: { id: 'area', items: Area.all.pluck('name') , title: 'エリア'}
        else
            render plain: '1'
        end
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
    
    def get_hash(arr)
        if arr[0].length == 1
            arr.map{|a| a[0]}
        else
            arr.group_by{|a| a[0]}.map{|k,v| [k, get_hash(v.map{ |a| a[1..-1]})]}
        end
    end
end
