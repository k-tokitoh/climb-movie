class RemoveAliasToRocks < ActiveRecord::Migration[5.0]
  def change
    remove_column :rocks, :alias, :string
  end
end
