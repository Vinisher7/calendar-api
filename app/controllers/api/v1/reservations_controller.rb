class Api::V1::ReservationsController < ApplicationController
  def index
    @reservation = Reservation.all
  end
end
