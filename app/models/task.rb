class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :due_date, presence: true

  enum :status, [:pending, :in_progress, :completed, :cancelled]
end
