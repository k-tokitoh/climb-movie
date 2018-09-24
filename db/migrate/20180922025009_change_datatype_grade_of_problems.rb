class ChangeDatatypeGradeOfProblems < ActiveRecord::Migration[5.0]
  def change
    change_column :problems, :grade, :integer
  end
end
