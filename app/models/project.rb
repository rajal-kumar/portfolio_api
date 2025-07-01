class Project < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :technology_stack, presence: true
  validates :repository_url, presence: true
end
