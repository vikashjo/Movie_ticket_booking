class Api::V1::ReviewsController < ApplicationController
  before_action :set_movie
  before_action :set_review, only: [:update, :destroy]
  
  def index
    @reviews = @movie.reviews.where(approved: true)
    if @reviews.empty?
      render json: {messages: "Not reviews for this movie"}
    else
      render json: @reviews
    end
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      render json: { messages: "Your review is created ", data: @review}
    else
      render json: { messages: "Invalid review", data: @review.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @review.update
      render json: { messages: "Your review is updated ", data: @review}
    else
      render json: { messages: "Invalid review", errors: @review.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.delete
      render json: { messages: "Your review is deleted", data: @review}
    else
      render json: { message: "Review not deleted", errors: @review.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
