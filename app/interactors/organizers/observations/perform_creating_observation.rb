module Organizers
  module Observations
    class PerformCreatingObservation
      include Interactor::Organizer

      organize ::Observations::CreateObservation, ::Notifications::CreateNotification, ::Notifications::SendNotification
    end
  end
end
