class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :video
      t.integer :hit
      t.boolean :approved

      t.timestamps
    end
  end
end
