class Area < ApplicationRecord
  belongs_to :region
  has_many :rocks
  validates :name, uniqueness: true, presence:true
end
