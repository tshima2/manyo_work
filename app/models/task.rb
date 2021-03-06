class Task < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  scope :status_search, ->(_status) { where(status: _status) }
  scope :name_like, ->(_query){ where('name like ?', "%#{_query}%") }
  scope :id_sort, ->{ order(id: :asc) }
  scope :created_sort, ->{ order(created_at: :desc) }
  scope :deadline_sort, ->{ order(deadline: :asc) }
end
