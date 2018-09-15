class PostsController < ApplicationController
    
    def index
        @posts = Post.all.page(params[:page]).per(10)
    end
    
    def update
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
                max_results: 10         #最大取得件数
            ).items                     #動画リソースのみにフィルター
            
            results.each do |result|
                Problem.find_by(name: problem.name).posts.create(video: result.id.video_id)
            end
        end
        
        redirect_to '/'
    end
    
    def search
        @posts = Post.where(id: params[:q])
        #byebug
        render 'index'
    end
    
    private

    def post_params
      params.require(:post).permit(:approved)
    end
    
end
