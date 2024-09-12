module Api
  module V1 
    class TicketsController < ApplicationController
      before_action :set_showtime

      def index
        @tickets = @showtime.movie.tickets
        render json: @tickets
      end

      def create
        
        ActiveRecord::Base.transaction do

          @seat = @showtime.seats.find_by(id: ticket_params[:seat_id], status: 'available')
          
          if @seat.nil?
            render json: {message: "Seat is not available, please choose another seat"}, status: :unprocessable_entity
          else
            @seat.lock!

            if Ticket.exists?(showtime_id: @showtime.id, seat_id: @seat.id)
              render json: { message: "Seat is already booked, Please choose some other seat"}, status: :unprocessable_entity
            else
              ticket = @showtime.tickets.create!(ticket_params.merge(user:current_user))

              @seat.update!(status: 'booked')

              ticket.reload

              ticket_price = calculate_ticket_price(ticket)
              ticket.update!(price: ticket_price)

              render json: {message: "Congratulations! tickets booked successfully", data: ticket.as_json(include: :seat)}, status: :created
              UserMailer.booking_confirmation(current_user, ticket).deliver_later
            end     
          end 
        end

      rescue ActiveRecord::StaleObjectError
        render json: { message: "The seat has been updated, please try booking again" }, status: :conflict
      rescue ActiveRecord::RecordInvalid => e
        render json: { message: e.message }, status: :unprocessable_entity
      end

      private

      def set_movie
        @movie = Showtime.find(params[:showtime_id]).movie
      end

      def set_showtime
        @showtime = Showtime.find(params[:showtime_id])
      end

      def ticket_params
        params.require(:ticket).permit(:seat_id)
      end

      def calculate_ticket_price(ticket)
        seat_price = Ticket::SEAT_PRICES[ticket.seat.seat_type]
        time_type = @showtime.movie_time_type(ticket.showtime)
        time_price = Ticket::TIME_PRICES[time_type]
        seat_price + time_price
      end
    end
  end
end