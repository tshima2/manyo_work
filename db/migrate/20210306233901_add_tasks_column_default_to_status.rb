class AddTasksColumnDefaultToStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :status, from: nil, to: 1    
  end
end
