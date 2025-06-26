class Project < ApplicationRecord
  STATUS = ["pending", "in_progress", "complete"]

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: STATUS, message: "%{value} is not a valid status" }
  validates :technology_stack, presence: true
  validates :repository_url, presence: true
end
