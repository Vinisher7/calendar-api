module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_reservation!, only: :create
      def index
        render json: { data: current_user }
      end

      def create
        result = Organizers::Reservations::PerformCreatingReservation.call(
          reservation: @reservation,
          notification_params: {
            user_id: current_user.id,
            notification_type: :reservation,
            description: 'Nova reserva feita!'
          }
        )

        unless result.success?
          return render json: { error: result.error, cause: result.cause }, status: :bad_request
        end

        render json: { data: result.response[:message] }, status: :created
      end

      private

      def set_reservation!
        @reservation = Reservation.new(customer_name: params[:customer_name], total_amount_cents: params[:total_amount_cents],
                        signal_amount_cents: params[:signal_amount_cents], entry_date_time: params[:entry_date_time],
                        out_date_time: params[:out_date_time], observation: params[:observation],
                        payment_status: params[:payment_status], user_id: current_user.id)
      end

      def reservation_params
        params.require(:reservation).permit(:customer_name, :total_amount_cents, :signal_amount_cents,
                                            :entry_date_time, :out_date_time, :observation, :payment_status)
      end
    end
  end
end
