class AddOtherNamesToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :other_names, :string
  end
end
