class Labelling < ApplicationRecord
  belongs_to :label
  belongs_to :task
  validates :task_id, uniqueness: { scope: [:label_id] }
  
  scope :label_is, ->(_id) { where(label_id: _id) }
end
