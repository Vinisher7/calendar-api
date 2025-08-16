module Api
  module V1
    class ReservationsController < ApplicationController
      def index
        @reservations = Reservation.all
      end

      def create
        @reservation = Reservation.new(reservation_params)
        return if @reservation.save

        render json: { error: @reservation.errors.full_messages },
               status: :unprocessable_entity
      end

      private

      def reservation_params
        params.require(:reservation).permit(:customer_name, :total_amount_cents, :signal_amount_cents,
                                            :entry_date_time, :out_date_time)
      end
    end
  end
end
