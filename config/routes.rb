Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'

  namespace :admin do
    resources :traders, only: [:new, :create] # Define routes for new and create actions
    resources :users do 
      get 'transactions'
      member do
        patch 'activate', to: 'users#activate_user'
        patch 'deactivate', to: 'users#deactivate_user'
      end
    end
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    get 'users/:id/edit', to: 'users#edit', as: :edit_admin_user
  end

  namespace :trader do
    get 'portfolio', to: 'portfolio#show'
    get 'portfolio/fetch_stock', to: 'portfolio#fetch_stock', as: :fetch_stock
    post 'portfolio', to: 'portfolio#process_order'
    get 'transactions', to: 'transactions#index'
  end
end
