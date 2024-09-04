module Api 
  module V1
    class HallsController < ApplicationController
      before_action :authorize_admin, only: [:create, :update, :destroy]
      before_action :set_hall, only: [:update, :destroy, :show]

      def index
        @halls = Hall.all
        render json: @halls
      end

      def show
        render json: @hall
      end 

      def create
        @hall = Hall.new(hall_params)
        if @hall.save
          render json: { message: "Hall created successfully", data: @hall}
        else
          render json: { message: "Not created", data: @hall.errors}
        end
      end

      def update        
        if @hall.update(hall_params)
          render json: { message: "Hall updated successfully", data: @hall}
        else
          render json: { message: "Not updated", data: @hall.errors}
        end
      end

      def destroy
        if @hall.destroy
          render json: {message: "Hall is deleted", data: @hall }
        else
          render json: { message: "Hall not deleted", data: @hall.errors }
        end       
      end

      private

      def hall_params
        params.require(:hall).permit(:name, :capacity)
      end

      def set_hall
        @hall = Hall.find(params[:id])
      end

      def authorize_admin
        unless current_user.email == ENV['ADMIN_EMAIL']
          render json: { message: "forbidden action"}
        end
      end
    end
  end
end