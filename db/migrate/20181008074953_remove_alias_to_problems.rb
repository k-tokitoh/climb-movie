class RemoveAliasToProblems < ActiveRecord::Migration[5.0]
  def change
    remove_column :problems, :alias, :string
  end
end
