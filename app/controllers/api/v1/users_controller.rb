module Api 
  module V1
    class UsersController <ApplicationController
      skip_before_action :authenticate, only: [:create]
      
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
