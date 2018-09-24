class ChangeDatatypeGradeOfProblems < ActiveRecord::Migration[5.0]
  def change
    # change_column :problems, :grade, :integer
    change_column :problems, :grade, 'integer USING CAST(grade AS integer)'
  end
end
