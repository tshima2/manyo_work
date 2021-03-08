class User < ApplicationRecord
  has_secure_password
  before_validation { email.downcase! }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :tasks
end
