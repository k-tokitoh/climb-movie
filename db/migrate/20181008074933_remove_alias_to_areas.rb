class RemoveAliasToAreas < ActiveRecord::Migration[5.0]
  def change
    remove_column :areas, :alias, :string
  end
end
