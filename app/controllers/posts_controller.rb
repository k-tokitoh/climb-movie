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
            'rocks.name as rock, ' +                # 
            'problems.name as problem, ' +          # 
            'problems.grade as grade, ' +
            'posts.id as post_id'
            
        matched_ids = Region.joins({areas: {rocks: {problems: :posts}}})
                            .select(selection_string).select{ |rec|             # joinして得たレコードrecに対し
            words = [rec.region, rec.area, rec.rock, rec.problem, rec.grade]
            params[:q].split().all?{ |qword|            # クエリをsplitして得られた各単語qwordに対して
                words.any?{ |word|                      # そのqwordが単語リストwordsに
                    word.include?(qword)                # 部分文字列として登場するか
                }                                       # 1回でも登場したらtrueを返す
            }
        }.map{ |rec| rec.post_id}
        @posts = Post.where(id: matched_ids).page(params[:page]).per(10)              # 選択されたidのみ表示する
        render 'index'
    end
    
    private

    def post_params
      params.require(:post).permit(:approved)
    end
    
    def get_words(post_id:)
        ps = Problem.includes(:posts).where('posts.id'=>post_id)    # idがpost_idのpostに紐づく課題たち
        psnames = ps.pluck(:name, :grade).flatten.uniq              # 課題名と級を格納した配列,flattenで二次元配列を一次元配列にする
        rocknames = ps.pluck(:rock_id).uniq.map{ |rock_id|          # 各課題の岩idに対し(重複をのぞいてから)
            rock = Rock.find(rock_id)                               # 岩を取得
            area = Area.find(rock.area_id)                          # エリア取得
            region = Region.find(area.region_id)                    # 地方取得
            [rock.name, area.name, region.name]                     # 岩、エリア、地方の名前
        }.flatten.uniq               # 複数の岩に渡るpostではここで、さらに連結される(実際はあまりないか?)
        psnames + rocknames          # 連結された課題名と、岩名をくっつける
    end
    
end
