require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: "sessions#login"
      resources :users
      resources :halls
      resources :movies do
        resources :reviews, only: [:index, :create]
        resources :showtimes, only: [:index, :create, :show] do
          resources :tickets, only: [:index, :create]
        end
      end
      resources :showtimes, only: [:update, :destroy]
      resources :reviews, only: [:update, :destroy]
      namespace :admin do
        resources :reviews, only: [] do
          member do
            patch 'approve'
            patch 'reject'
          end
        end
      end
    end
  end
  mount Sidekiq::Web => '/sidekiq'
end

