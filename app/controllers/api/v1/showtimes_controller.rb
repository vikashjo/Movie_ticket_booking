module Api 
  module V1
    class ShowtimesController < ApplicationController
      before_action :authorize_admin, only: [:create, :update, :destroy]
      before_action :set_showtime, only: [:update, :destroy]
      before_action :set_movie, only: [:index, :create, :update, :destroy]
      before_action :set_hall, only: [:create, :update, :destroy]

      def index
        @showtimes = @movie.showtimes

        @showtimes = @showtimes.where(start_time: params[:start_time]) if params[:start_time].present?
        @showtimes = @showtimes.where(end_time: params[:end_time]) if params[:end_time].present?
        
        render json: @showtimes
      end

      def show

      end

      def create
        @showtime = @movie.showtimes&.create(showtime_params)
        if @showtime.save 
          render json: { message: "Showtime is created", data: @showtime}
        else
          render json: {message: "invalid", data: @showtime.errors}
        end
      end

      def update
        if @showtime.update(showtime_params)
          render json: { message: "Showtime is created", data: @showtime}
        else
          render json: {message: "invalid", data: @showtime.errors}
        end
      end

      def destroy
        if @showtime.destroy
          render json: { message: "Showtime is deleted", data: @showtime}
        else
          render json: {message: "Not deleted", data: @showtime.errors}
        end
      end

      private

      def showtime_params
        params.require(:showtime).permit(:start_time, :end_time, :hall_id)
      end

      def set_showtime
        @showtime = Showtime.find(params[:id])
      end

      def set_movie 
        @movie = Movie.find_by(id: params[:movie_id])
        unless @movie
          render json: { message: "Movie not found" }, status: :not_found
        end
      end

      def set_hall 
        @hall = Hall.find(params[:showtime][:hall_id])
      end

      def authorize_admin
        unless current_user&.email == ENV['ADMIN_EMAIL']
          render json: { message: "Forbidden action" }, status: :forbidden
        end
      end
    end
  end
end