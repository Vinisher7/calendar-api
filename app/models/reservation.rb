class Reservation < ApplicationRecord
  validates :customer_name, presence: true, length: { maximum: 50 }

  validates :total_amount_cents,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  validates :signal_amount_cents,
            presence: true,
            numericality: { less_than: :total_amount_cents }

  validates :entry_date_time, presence: true

  validates :out_date_time,
            presence: true,
            comparison: { less_than: :entry_date_time }
end
