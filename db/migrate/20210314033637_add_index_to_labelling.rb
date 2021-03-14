class AddIndexToLabelling < ActiveRecord::Migration[5.2]
  def change
    add_index :labellings, [:task_id, :label_id], unique: true
  end
end
