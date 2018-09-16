class Problem < ApplicationRecord
  belongs_to :rock
  has_and_belongs_to_many :posts
  validates :name, uniqueness: true, presence:true
  validates :grade, inclusion: { in: %w(10級 9級 8級 7級 6級 5級 4級 3級 2級 1級 初段 二段 三段 四段 五段 六段) }
end
