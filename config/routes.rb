Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
  namespace :admin do
    resources :traders, only: [:new, :create] # Define routes for new and create actions
    resources :users do 
      get 'transactions'
      member do
        patch 'activate', to: 'users#activate_user'
      end
    end
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    get 'users/:id/edit', to: 'users#edit', as: :edit_admin_user
  end  
end
