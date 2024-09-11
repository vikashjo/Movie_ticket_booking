class Api::V1::SeatsController < ApplicationController
  before_action :set_seat, only: %i[ show ]
  before_action :set_showtime, only: [:availability, :index]

# Fetching Available Seats: List all available seats for a particular showtime.
# Seat Reservation: Reserve a seat before the ticket is booked.
# Seat Release: Release a seat if the user cancels the reservation.
# Seat Updates: Allow admins to update or manage seats (optional).

  def availability
    @available_seats = @showtime.seats
    render json: @availabile_seats
  end

  def index
    @seats = @showtime.seats.where(status: 'available')

    render json: @seats
  end

  # GET /seats/1
  def show
    render json: @seat
  end


  private
   
  def set_seat
    @seat = Seat.find(params[:id])
  end

  def set_showtime
    @showtime = Showtime.find(params[:showtime_id])
  end
end
