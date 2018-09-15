class ChangeDatatypeApprovedOfPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :approved, :string
  end
end
