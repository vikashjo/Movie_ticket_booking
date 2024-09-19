require 'csv'
module Api 
  module V1
    class HallsController < ApplicationController
      before_action :authorize_admin, only: [:create, :update, :destroy, :import_csv]
      before_action :set_hall, only: [:update, :destroy, :show]

      def import_csv
        file = params[:file]

        unless file
          render json: { error: "Please provide a CSV file" }, status: :unprocessable_entity
        end

        CSV.foreach(file.path, headers: true) do |row|
          Hall.create!(
            name: row["Name"],
            capacity: row["Capacity"]
          )
        end

        render json: { message: "CSV imported successfully" }, status: :ok
      rescue => e
        render json: { error: "Failed to import CSV: #{e.message}" }, status: :unprocessable_entity
      end

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