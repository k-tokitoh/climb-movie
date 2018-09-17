class PostsController < ApplicationController
    
    def index
        if session[:admin]                                                      #管理ユーザの場合、
            @posts = Post.all.page(params[:page]).per(10)                       #全てのポストをフィードして、
            @approval ={ undecided: true, OK: true, NG: true }                  #承認状況チェックボックスの初期値を設定する
        else                                                                    #一般ユーザの場合、
            @posts = Post.where(approved: 'OK').page(params[:page]).per(10)     #公開が許可されたポストのみをフィードする
        end
    end
    
    def update                                  #承認状況等の更新
        @post = Post.find(params[:id])
        @post.update_attributes(post_params)    #post_paramsはprivateで定義している

        redirect_to '/'
    end

    def get_youtube_videos
        #以下の３行、ここに書くのでよいのかな？
        require 'google/apis/youtube_v3'
        youtube = Google::Apis::YoutubeV3::YouTubeService.new       
        youtube.key = "AIzaSyCkC3fQVnKl2htGzQuF_x6ovTCoEzOO1ro"     #APIkey
        
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
        selection_string =                          # joinした後のActiveRecord_Relationでselectするときは、
            'regions.name as region, '+             # カラム名(nameとか)が重複するときは、asで名付け直さないといけないらしい
            'areas.name as area, ' +                # 今回は全て名付け直しておいた。
            'rocks.name as rock, ' +                 
            'problems.name as problem, ' +           
            'problems.grade as grade, ' +
            'posts.id as post_id, ' +
            'posts.approved as approved'
        q = params[:q].gsub(/\p{blank}/,' ')        #検索クエリの全角スペースを半角スペースに置換する
        
        approval_condition = params[:approval].keys.map{|key|key.to_s} 
        #ex. params[:approval] = {"OK"=>"true", "NG"=>"true"}
        #ex. approval_condition = ["OK", "NG"]

        db = Region.joins({areas: {rocks: {problems: :posts}}}).select(selection_string)
        matched_ids =
            db.select{ |record| approval_filter(record, approval_condition) && freeword_search(record, q)
            }.map{ |record| record.post_id}

        @posts = Post.where(id: matched_ids).page(params[:page]).per(10)              # 選択されたidのみ表示する

        render 'index'
    end
    
    private

    def post_params
      params.require(:post).permit(:approved)
    end

    def freeword_search(record,q)
        words = [record.region, record.area, record.rock, record.problem, record.grade]
        match_or_not =
            q.split().all?{ |qword|             # クエリをsplitして得られた各単語qwordに対して
                words.any?{ |word|              # そのqwordが単語リストwordsに
                    word.include?(qword)        # 部分文字列として登場するか
                }                               # 1回でも登場したらtrueを返す
            }                                           
        return match_or_not
    end

    def approval_filter(record, approval_condition)
        approval_condition.include?(record.approved)
    end
    
end
