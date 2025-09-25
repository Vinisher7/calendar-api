class Observation < ApplicationRecord
  validates :description, :date, presence: true
  validates :description, length: { maximum: 100, minimum: 5}

  belongs_to :user
end
