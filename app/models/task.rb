class Task < ApplicationRecord
  enum priority: { 低: 0, 中: 1, 高: 2 }
#  enum priority: { t('tasks.enum_priority_low'): 0, t('tasks.enum_priority_normal'): 1, t('tasks.enum_priority_high'): 2 }  
  validates :name, presence: true, uniqueness: true
  belongs_to :user

  scope :status_search, ->(_status) { where(status: _status) }
  scope :name_like, ->(_name){ where('name like ?', "%#{_name}%") }

  scope :id_sort, ->{ order(id: :asc) }
  scope :created_sort, ->{ order(created_at: :desc) }
  scope :deadline_sort, ->{ order(deadline: :asc) }
  scope :priority_sort, ->{ order(priority: :desc) }

end
