class Post < ApplicationRecord
    has_and_belongs_to_many :problems
    validates :video, uniqueness: true, presence:true
    validates :approved, inclusion: { in: %w(undecided OK NG) }   #%wで配列をつくる。
end
