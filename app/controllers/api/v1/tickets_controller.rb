module Api
  module V1 
    class TicketsController < ApplicationController
      before_action :set_showtime

      def index
        @tickets = @showtime.movie.tickets
        render json: @ticket
      end

      def create

      #   @ticket = @showtime.tickets.new(ticket_params.merge(user:current_user))
      #   if @ticket.save
      #     render json: {message: "Congratulations! tickets booked successfully", data: @ticket}
      #   else
      #     render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      #   end
      # end
        
        ActiveRecord::Base.transaction do
          @showtime.lock!

          if Ticket.exists?(showtime_id: @showtime.id, seat_number: params[:ticket][:seat_number])
            render json: { message: "Seat is already booked, Please choose some other seat"}, status: :unprocessable_entity
          else
            @ticket = @showtime.tickets.create!(ticket_params.merge(user:current_user))
            render json: {message: "Congratulations! tickets booked successfully", data: @ticket}, status: :created
            UserMailer.booking_confirmation(current_user, @ticket).deliver_later
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
        params.require(:ticket).permit(:seat_number)
      end
    end
  end
end