module Api
  module V1
    module Admin
      class ReviewsController < ApplicationController
        before_action :authorize_admin
        before_action :set_review

        def approve
          if @review.update(approved: true)
            render json: { messages: "Review Approved", data: @review }
          else
            render json: { messages: "Review not approved", errors: @review.errors}, status: unprocessable_entity
          end
        end

        def reject
          if @review.update(approved: false)
            render json: { messages: "Review rejected", data: @review }
          else
            render json: { messages: "Review not rejected", errors: @review.errors}, status: unprocessable_entity
          end
        end

        private

        def set_review
          @review = Review.find(params[:id])
        end

        def authorize_admin
          unless current_user&.email == ENV['ADMIN_EMAIL']
            render json: { message: "Forbidden action" }, status: :forbidden
          end
        end
      end
    end
  end
end