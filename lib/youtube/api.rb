class Youtube::Api
  def initialize
    @api = Google::Apis::YoutubeV3::YouTubeService.new
    @api.key = ENV["YOUTUBE_API_KEY"]
  end

  def search(problem)
    @api.list_searches(
      "id, snippet",				#取得内容
      type: "video",				#チャンネルやプレイリストを含まず、動画のみ取得する
      q: problem.name,			#検索キーワードの指定（検索方法は他にも色々あり）
      max_results: 10				#最大取得件数
    ).items									#動画リソースのみにフィルター
    .map {|api_response_video| Youtube::Video.new(api_response_video)}
  end
end
