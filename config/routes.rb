Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users
  ActiveAdmin.routes(self)
  post "/stripe/webhook", to: "stripe_webhooks#create"

  root 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :pages, only: [:show], param: :slug

  # Cart
  resource :cart, only: [:show] do
    post   :add_item
    patch  :update_item
    delete :remove_item
  end

  # Checkout
  resource :checkout, only: [:show, :create]
  resources :orders, only: [:index, :show]

  # Profile
  resource :profile, only: [:show, :edit, :update]
end