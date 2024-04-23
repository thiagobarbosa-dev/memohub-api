class User < ApplicationRecord
  has_secure_password
  has_many :notebooks, dependent: :destroy
  validates :login, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true

end
