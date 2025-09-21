class Payment < ApplicationRecord
  belongs_to :reservations
  belongs_to :users
end
