class Region < ApplicationRecord
  has_many :areas
  validates :name, uniqueness: true, presence:true
end
