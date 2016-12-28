Rails.application.routes.draw do

  resources :series, only: [:index]
  resources :releases, only: [:index]
end
