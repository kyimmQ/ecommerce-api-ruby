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

      resources :products, only: [ :index, :show, :destroy, :create, :update ] do
        resource :product_variants, path: "variants", only: [ :create, :update, :destroy ]
      end

      get "shop/:shop_id/products", to: "products#shop_products"

      resources :product_options, only: [] do
        resources :product_option_values, path: "values", only: [ :index, :create, :update, :destroy ]
      end

      resources :orders, only: [ :create, :index, :show, :update ]
      resources :cart, only: [ :create, :index, :update, :destroy ]
      resources :cart_items, only: [ :create, :update ]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
