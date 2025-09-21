class Observation < ApplicationRecord
  validates :description, :date_time, presence: true
  validates :description, length: { maximum: 100, minimum: 5}

  belongs_to :users
end
