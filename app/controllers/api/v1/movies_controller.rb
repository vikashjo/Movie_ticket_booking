module Api 
  module V1
    class MoviesController < ApplicationController
      before_action :authorize_admin, only: [:create, :update, :destroy]
      before_action :set_movie, only: [:show, :update, :destroy]

      def export_csv
        movies = Movie.all

        csv_data = CSV.generate(headers:true) do |csv|
          csv << ["ID", "TITLE", "DESCRIPTION", "DURATION", "LANGUAGE", "GENRE", "CAST", "DIRECTOR"]

          movies.each do |movie|
            csv << [movie.id, movie.title, movie.description, movie.duration, movie.language, movie.genre, movie.cast, movie.director]
          end
        end

        send_data csv_data, filename: "movies-#{Date.today}.csv", type: 'text/csv'
      end

      def index
        @movies = Movie.all

        @movies = @movies.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?
        @movies = @movies.where("genre ILIKE ?", "%#{params[:genre]}%") if params[:genre].present?

        render json: @movies
      end

      def show
        render json: @movie
      end

      def create
        @movie = Movie.new(movie_params)
        if @movie.save
          render json: { message: "Movie created successfully", data: @movie}
        else
          render json: { message: "Not created", data: @movie.errors}
        end
      end

      def update        
        if @movie.update(movie_params)
          render json: { message: "Meviw updated successfully", data: @hall}
        else
          render json: { message: "Not updated", data: @movie.errors}
        end
      end

      def destroy
        if @movie.destroy
          render json: {message: "Movie is deleted", data: @movie }
        else
          render json: { message: "Movie not deleted", data: @movie.errors }
        end       
      end

      private

      def movie_params
        params.require(:movie).permit(:title, :description, :duration, :genre, :director, :cast, :language)
      end

      def set_movie
        @movie = Movie.find(params[:id])
      end

      def authorize_admin
        unless current_user.email == ENV['ADMIN_EMAIL']
          render json: { message: "forbidden action"}
        end
      end
    end
  end
end