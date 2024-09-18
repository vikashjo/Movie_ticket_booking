module Api 
  module V1
    class UsersController <ApplicationController
      skip_before_action :authenticate, only: [:create]

      def search
        identifier = params[:identifier]
        if identifier.match?(/\A[^@\s]+@[^@\s]+\z/)
          @user = User.find_by_email(identifier)
        else
          render json: { error: 'Invalid phone number or email' }, status: :bad_request
          return
        end

        if @user
          
          render json: { name: @user }
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end
      
      def index
        @users = User.all 
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: "User is created", data: @user}
        else
          render json: { message: "User not created", data: @user.errors}
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
