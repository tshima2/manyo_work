class AddTasksColumnDefaultToPriority < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :priority, from: nil, to: 1
  end
end
