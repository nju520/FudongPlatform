Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root to: 'home#index'
  get 'signup' => 'users#new', as: :signup
  resources :users
  get 'login', to:  'sessions#new', as: :login
  delete '/logout' => 'sessions#destroy', as: :logout
  resources :sessions

  resources :categories, only: [:show]
  resources :products, only: [:show]

  resources :shopping_carts
  resources :addresses do
    member do
      put :set_default_address
    end
  end
  resources :orders
  resources :payments, only: [:index] do
    collection do
      get :generate_pay
      get :pay_return
      post :pay_notify
      get :success
      get :failed
    end
  end

  # 用户信息
  namespace :dashboard do
    resource :profile, only: [:show, :edit, :update]
    resources :orders, only: [:index, :update]
    resources :main_orders, only: [:index]
    resources :addresses, only: [:index]
  end

  # 商家
  namespace :seller do
    root to: 'home#index'
    resources :home, only: [:index]
    get 'signup' => 'users#new', as: :signup
    resources :users
    get 'login', to: 'sessions#new', as: :login
    delete 'logout', to: 'sessions#destroy', as: :logout
    resources :sessions
    resources :categories, only: [:index, :show]
    resources :products do
      resources :product_images, only: [:index, :create, :update, :destroy]
    end
    resources :orders, only: [:index, :update]
    resources :pack_orders, only: [:index]
  end

  # 管理员(系统后台分配账号)
  namespace :admin do
    root to: 'home#index'
    resources :home, only: [:index]
    get 'login', to: 'sessions#new', as: :login
    delete 'logout', to: 'sessions#destroy', as: :logout
    resources :sessions
    resources :categories
    resources :products, only: [:index, :show, :destroy] do
      resources :product_images, only: [:index]
    end
    resources :orders, only: [:index, :update]
  end
end
