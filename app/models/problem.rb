class Problem < ApplicationRecord
  belongs_to :rock
  has_and_belongs_to_many :posts
end
