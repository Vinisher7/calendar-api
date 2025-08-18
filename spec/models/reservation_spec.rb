require 'rails_helper'

RSpec.describe Reservation, type: :model do
  context 'Testing presence validation in each attribute' do
    let(:reservation) do
      Reservation.new(customer_name: '', total_amount_cents: nil, signal_amount_cents: nil,
                      entry_date_time: '', out_date_time: '')
    end
    it 'Creating with empty and nil values' do
      expect(reservation).to_not be_valid
    end
  end

  context 'Testing the business logic' do
    let(:reservation) do
      Reservation.new(customer_name: 'Test', total_amount_cents: 10, signal_amount_cents: 9,
                      entry_date_time: '2025-08-12 10:10:10', out_date_time: '2025-08-20 10:10:10')
    end
    it 'Creating a valid reservation' do
      expect(reservation).to be_valid
    end

    it 'Creating with signal_amount greather than total_amount ' do
      reservation.signal_amount_cents = reservation.total_amount_cents + 1
      expect(reservation).to_not be_valid
    end

    it 'Creating with out_date_time less than entry_date_time' do
      reservation.out_date_time = reservation.entry_date_time.prev_day
      expect(reservation).to_not be_valid
    end

    it 'Creating with entry_date_time greater than out_date_time' do
      reservation.entry_date_time = reservation.out_date_time.next_day
      expect(reservation).to_not be_valid
    end
  end
end
