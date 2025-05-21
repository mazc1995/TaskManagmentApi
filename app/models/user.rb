class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 4 }
  
  enum :role, [:user, :admin]
end
