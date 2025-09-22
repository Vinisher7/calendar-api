module Notifications
  class CreateNotification
    include Interactor

    def call
      notification = Notification.new(context.notification_params)

      unless notification.save
        return context.fail!(error: 'Falha ao criar objeto de notificação', cause: notification.errors.full_messages)
      end

      context.notification = notification

      def rollback
        context.notification.destroy
      end
    end
  end
end
