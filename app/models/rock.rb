class Rock < ApplicationRecord
  belongs_to :area
  has_many :problems
  validates :name, uniqueness: true, presence:true
end
