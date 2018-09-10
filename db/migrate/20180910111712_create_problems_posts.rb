class CreateProblemsPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :problems_posts, id: false do |t|
      t.references :problem, foreign_key: true
      t.references :post, foreign_key: true
    end
  end
end
