class AddAliasToRocks < ActiveRecord::Migration[5.0]
  def change
    add_column :rocks, :alias, :string
  end
end
