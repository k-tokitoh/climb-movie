class AddAliasToAreas < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :alias, :string
  end
end
