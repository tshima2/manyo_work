class AddConstraintNotNullToNameToTasks < ActiveRecord::Migration[5.2]
  def up
    change_column_null :tasks, :name, false
  end
  def down
    change_column_null :tasks, :name, true
  end
end
