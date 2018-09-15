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
        matched_ids = Post.pluck(:id).select{ |i|       # ポストの各idに対し、
            words = get_words(post_id: i)               # まずそれにひもづく単語リストwordsを取得

            params[:q].split().map{ |qword|             # クエリをsplitして得られた各単語qwordに対して
                words.any?{ |word|                      # そのqwordが単語リストwordsに
                    word.include?(qword)                # 部分文字列として登場するか
                }                                       # 1回でも登場したらtrueを返す
            }.all?                                      # 全てのqwordが条件を満たすidを取ってくる
            
        }
        #byebug
        logger.debug('prams')
        logger.debug(params[:q])
        logger.debug(matched_ids)
        @posts = Post.where(id: matched_ids).page(params[:page]).per(10)              # 選択されたidのみ表示する
        render 'index'
    end
    
    private

    def post_params
      params.require(:post).permit(:approved)
    end
    
    def get_words(post_id:)
        ps = Problem.includes(:posts).where('posts.id'=>post_id)    # idがpost_idのpostに紐づく課題たち
        psnames = ps.pluck(:name, :grade).flatten.uniq              # 課題名と級を格納した配列
        rocknames = ps.pluck(:rock_id).uniq.map{ |rock_id|          # 各課題の岩idに対し(重複をのぞいてから)
            rock = Rock.find(rock_id)                               # 岩を取得
            area = Area.find(rock.area_id)                          # エリア取得
            region = Region.find(area.region_id)                    # 地方取得
            [rock.name, area.name, region.name]                     # 岩、エリア、地方の名前
        }.flatten.uniq               # 複数の岩に渡るpostではここで、さらに連結される(実際はあまりないか?)
        psnames + rocknames          # 連結された課題名と、岩名をくっつける
    end
    
end
