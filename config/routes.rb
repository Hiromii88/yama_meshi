Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root 'home#index'
  resources :recipes, only: [:show]
  post 'suggest', to: 'suggests#create', as: :suggest
end
