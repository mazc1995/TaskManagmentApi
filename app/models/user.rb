class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :full_name, presence: true
  validates :role, presence: true
  
  enum :role, [:user, :admin]
end
