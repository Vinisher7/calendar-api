module Organizers
  module Reservations
    class PerformCreatingReservation
      include Interactor::Organizer

      organize ::Reservations::CreateReservation, ::Notifications::CreateNotification, ::Notifications::SendNotification
    end
  end
end
