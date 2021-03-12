class User < ApplicationRecord
  has_secure_password
  before_validation { email.downcase! }
  before_destroy :ensure_not_last_administrator
  before_update :ensure_not_last_administrator
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
#  validates :admin, presence: true
  has_many :tasks, dependent: :destroy

  private
  def ensure_not_last_administrator
    if(self.admin && User.where(admin: true).count == 1)
      byebug
      throw :abort
    end
  end
end
