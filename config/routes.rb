Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"

      get "users/me", to: "users#me"
      put "users/me", to: "users#update_me"
      resources :users, only: [ :index, :show, :destroy ]

      resources :categories, only: [ :index, :create, :update, :destroy ] do
        resources :product_options, only: [ :index, :create, :destroy ]
      end

      delete "product_options/:id", to: "product_options#delete_option"

    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
