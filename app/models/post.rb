class Post < ApplicationRecord
    has_and_belongs_to_many :problems
end
