Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'login', to: "sessions#login"
      resources :users
      resources :halls
      resources :movies do
        resources :showtimes, only: [:index, :create] do
          resources :tickets, only: [:index, :create]
        end
      end
      resources :showtimes, only: [:update, :destroy]
    end
  end
end
