class Youtube::Video
  attr_reader :title, :snippet, :id

  def initialize(api_response_video)
    @title = trim(api_response_video.snippet.title)
    @snippet = @title + trim(api_response_video.snippet.description)
    @id = api_response_video.id.video_id
  end

  private

  # youtubeの動画情報及びDB側の情報を整形し、照合可能にする
  def trim(text)
    return text if text.nil?

    # 絵文字などの4バイト文字を取り除く（mysqlが絵文字に対応していないため）
    text.each_char do |b|
      text.delete!(b) if b.bytesize == 4
    end

    # 大文字を小文字にする
    text.downcase!

    # 全角英数字を半角にする
    text.tr!('０-９ａ-ｚ', '0-9a-z')

    # "・"を取り除く
    text.tr!("・", "")

    # 半角及び全角のスペースを取り除く
    text.gsub!(/(\s|　)+/, '')

    # グレード表記を統一する
    [GRADE_QDver, GRADE_chara].each do |hash|
      hash.each do |grade_int, grade_string|
        text.gsub!(/#{grade_string}/, GRADE_CORRESPONDENCE.to_h.invert[grade_int])
      end
    end

    return text
  end
end
