class AddAliasToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :alias, :string
  end
end
