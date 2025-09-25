class Payment < ApplicationRecord
  belongs_to :reservation
  belongs_to :user

  private

  def reservation_exists?
    return if Reservation.exists?(id: reservations_id)

    errors.add(:base, 'Reserva inexistente!')
  end
end
