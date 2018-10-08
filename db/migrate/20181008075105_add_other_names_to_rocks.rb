class AddOtherNamesToRocks < ActiveRecord::Migration[5.0]
  def change
    add_column :rocks, :other_names, :string
  end
end
