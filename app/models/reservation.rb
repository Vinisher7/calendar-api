class Reservation < ApplicationRecord
  validates :customer_name, presence: true, length: { maximum: 50 }

  validates :total_amount_cents,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }

  validates :signal_amount_cents,
            presence: true,
            numericality: { less_than: :total_amount_cents }

  validates :entry_date_time,
            presence: true,
            comparison: { less_than: :out_date_time },
            uniqueness: true

  validates :out_date_time,
            presence: true,
            comparison: { greater_than: :entry_date_time },
            uniqueness: true

  validate :block_friday_reservations

  validate :block_weekend_reservations_with_out_date_in_same_day

  validate :block_period_reservations

  private

  def block_friday_reservations
    return unless (entry_date_time.to_date..out_date_time.to_date).any?(&:friday?)

    errors.add(:entry_date_time, "Can't create a reservation on a friday")
  end

  def block_weekend_reservations_with_out_date_in_same_day
    if entry_date_time.saturday? || entry_date_time.sunday? && out_date_time.to_date == entry_date_time.to_date
      errors.add(:entry_date_time, "Can't create a reservation on weekend in the same day!")
    end
  end

  def block_period_reservations
    start_date = entry_date_time.beginning_of_month
    end_date = entry_date_time.end_of_month
    month_reservations = Reservation.where(entry_date_time: start_date..end_date)
    month_reservations.each do |date_taken|
      if (entry_date_time.to_date..out_date_time.to_date).overlaps?(date_taken.entry_date_time.to_date..date_taken.out_date_time.to_date)
        errors.add(:entry_date_time, 'This period of time has already been taken!')
      end
    end
  end
end
