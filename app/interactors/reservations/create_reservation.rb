module Reservations
  class CreateReservation
    include Interactor

    def call
      reservation = context.reservation
      unless reservation.save
        return context.fail!(error: 'Não foi possível criar a reserva!', cause: reservation.errors.full_messages)
      end

      context.response = { message: 'Reserva criada com sucesso!' }
    end
  end
end
