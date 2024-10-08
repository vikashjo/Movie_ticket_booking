require 'sidekiq/web'

Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      resources :webhooks, only: [:create]
      resources :payments, only: [:create]
      post 'payments/collect', to: 'payments#collect_payment_info'
      post 'login', to: "sessions#login"
      resources :users, only: [:index, :create]
      get 'users/:identifier', to: 'users#search', constraints: { identifier: /[^\/]+/ }
      resources :halls do 
        collection do
          post 'import_csv'
        end
      end 
      resources :movies do
        resources :reviews, only: [:index, :create]
        resources :showtimes, only: [:index, :create, :show] do
          resources :tickets, only: [:index, :create]
          resources :seats, only: [:index, :show]
        end
        collection { get 'export_csv'}
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

