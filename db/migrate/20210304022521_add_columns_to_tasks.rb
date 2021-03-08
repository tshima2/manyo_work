class AddColumnsToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, null: true, default: '9999-1-1'
    add_column :tasks, :priority, :integer, null: true, default: 0
    add_column :tasks, :status, :integer, null: true, default: 0
  end
end

