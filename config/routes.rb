Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Buyer (Customer) Web Interface
  namespace :buyer do
    root "products#index"

    # Authentication
    get "login", to: "auth#login"
    post "login", to: "auth#create_session"
    get "register", to: "auth#register"
    post "register", to: "auth#create_account"
    delete "logout", to: "auth#logout"

    # Products
    resources :products, only: [ :index, :show ] do
      collection do
        get "category/:category_id", to: "products#by_category", as: :category
      end
    end

    # Cart
    get "cart", to: "cart#index"
    post "cart/add", to: "cart#add_item"
    patch "cart/:id", to: "cart#update_item", as: :update_cart_item
    delete "cart/:id", to: "cart#remove_item", as: :remove_cart_item

    # Orders
    resources :orders, only: [ :index, :show, :create ] do
      collection do
        get "checkout", to: "orders#checkout"
      end
    end

    # Profile
    get "profile", to: "profile#show"
    get "profile/edit", to: "profile#edit"
    patch "profile", to: "profile#update"
  end

  # Admin (Ops) Web Interface
  namespace :ops do
    root "dashboard#index"

    # Authentication
    get "login", to: "auth#login"
    post "login", to: "auth#create_session"
    delete "logout", to: "auth#logout"

    # Dashboard
    get "dashboard", to: "dashboard#index"

    # Products Management
    resources :products

    # Categories Management
    resources :categories

    # Orders Management
    resources :orders, only: [ :index, :show, :update, :destroy ]

    # Users Management
    resources :users, only: [ :index, :show, :edit, :update, :destroy ]
  end

  # Redirect root to buyer interface
  root "buyer/products#index"

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
