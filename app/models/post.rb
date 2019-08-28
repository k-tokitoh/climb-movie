class Post < ApplicationRecord
  has_and_belongs_to_many :problems
  validates :video, uniqueness: true, presence:true
  validates :approved, inclusion: { in: %w(undecided OK NG suspended) }   #%wで配列をつくる。

  def self.create_from_youtube
    youtube = Youtube::Api.new

    Problem.all.each do |problem|
      videos = youtube.search(problem)

      videos.each do |video|
        matched_post = Post.find_by(video: video.id)
        # 既にそのvideo_idを持っている場合、video_id以外の属性を更新する
        if matched_post.present?
          matched_post.update(title: video.title)
        # まだそのvideo_idを持っていない場合、新たにpostを作成する
        else
          matched_post = problem.posts.create(video: video.id, title: video.title, approved: 'undecided', hit: 0)
        end

        # youtubeの動画情報が、紐づけようとしているエリアの名前（又はその別名）を含むか調べる
        if problem.rock.area.other_names.present?
          area_match = true if problem.rock.area.other_names.split(',').unshift(problem.rock.area.name).any?{|i|video.snippet.include?(i)}
        else
          area_match = true if video.snippet.include?(problem.rock.area.name)
        end

        # youtubeの動画情報が、紐づけようとしている課題の名前（又はその別名）を含むか調べる
        if problem.other_names.present?
          problem_name_match = true if problem.other_names.split(',').unshift(problem.name).any?{|i|video.snippet.include?(i)}
        else
          problem_name_match = true if video.snippet.include?(problem.name)
        end

        # youtubeの動画情報が、紐づけようとしている課題のグレードを含むか調べる（表記法はtrim()により既に統一してある）
        problem_grade_match = true if video.snippet.include?(GRADE_CORRESPONDENCE.to_h.invert[problem.grade])

        # youtubeの動画情報が、紐づけようとしているエリアの名前、課題の名前及びグレードを含む場合、その動画を直ちに公開する
        if area_match && problem_name_match && problem_grade_match
          matched_post.update(approved: 'OK')
        end
      end
    end
  end
end
