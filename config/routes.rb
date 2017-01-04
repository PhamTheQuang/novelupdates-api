Rails.application.routes.draw do
  root to: 'releases#index'

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :series, only: [:index]
  resources :releases, only: [:index]
end
