class CreatePostsProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :posts_problems, id: false do |t|
      t.references :post, foreign_key: true
      t.references :problem, foreign_key: true
    end
  end
end
