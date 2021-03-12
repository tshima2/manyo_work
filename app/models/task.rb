class Task < ApplicationRecord
  enum priority: { 低: 0, 中: 1, 高: 2 }
#  enum priority: { t('tasks.enum_priority_low'): 0, t('tasks.enum_priority_normal'): 1, t('tasks.enum_priority_high'): 2 }  
  validates :name, presence: true, uniqueness: true
  belongs_to :user

  scope :status_search, ->(_status) { where(status: _status) if _status.present? }
  scope :name_like, ->(_name){ where('name like ?', "%#{_name}%") if _name.present? }

=begin  
  scope :created_sort, ->(_flg){ order(created_at: :desc) if _flg }
  scope :expired_sort, ->(_flg){ order(deadline: :asc) } if _flg }
  scope :priority_sort, ->(_flg){ order(priority: :desc) } if _flg }
=end

  scope :alter_sort_by, ->(_params){
    if(_params.has_key?(:sort_created)) then order(created_at: :desc)
    elsif(_params.has_key?(:sort_expired)) then order(deadline: :asc)
    elsif(_params.has_key?(:sort_priority)) then order(priority: :desc)
    else order(id: :asc)
    end
  }

end
