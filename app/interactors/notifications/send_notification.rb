module Notifications
  class SendNotification
    include Interactor

    def call
      binding.irb
      ActionCable.server.broadcast "NotificationsChannel", { data: context[:notification] }
    end
  end
end
