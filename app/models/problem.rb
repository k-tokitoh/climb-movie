class Problem < ApplicationRecord
  belongs_to :rock
  has_and_belongs_to_many :posts
  validates :name, uniqueness: true, presence:true
  validates :grade, inclusion: { in: 1..16 }
end
