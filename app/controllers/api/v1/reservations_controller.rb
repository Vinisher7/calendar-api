class Api::V1::ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all
  end

  def create
    @reservation = Reservation.new(reservation_params)
    render json: { error: @reservation.errors.full_messages } unless @reservation.save
  end

  private

  def reservation_params
    params.require(:reservation).permit(:customer_name, :total_amount_cents, :signal_amount_cents,
    :entry_date_time, :out_date_time)
  end
end
