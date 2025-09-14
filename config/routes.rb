Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root 'home#index'
  post 'suggest', to: 'suggests#create', as: :suggest

  resources :recipes, only: [:show] do
    member do
      get :result
    end
  end

  post '/callback' => 'linebot#callback'
end
