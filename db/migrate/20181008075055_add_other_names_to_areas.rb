class AddOtherNamesToAreas < ActiveRecord::Migration[5.0]
  def change
    add_column :areas, :other_names, :string
  end
end
