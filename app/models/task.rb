class Task < ApplicationRecord
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings


  enum priority: { 低: 0, 中: 1, 高: 2 }
  validates :name, presence: true, uniqueness: true
  belongs_to :user

  scope :label_search, -> (_label_id) { joins(:labellings).merge(Labelling.label_is _label_id) if _label_id.present? }
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
