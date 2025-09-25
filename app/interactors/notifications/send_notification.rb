module Notifications
  class SendNotification
    include Interactor

    def call
      ActionCable.server.broadcast "NotificationsChannel", { notification: context[:notification],
                                                             data: context[:data] }
    end
  end
end
