class CreateRocks < ActiveRecord::Migration[5.0]
  def change
    create_table :rocks do |t|
      t.string :name
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
