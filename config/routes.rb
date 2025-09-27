Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resources :users, only: [] do
    member do
      post :line_link
      get :line_link_show
    end
  end

  post 'suggest', to: 'suggests#create', as: :suggest

  resources :recipes, only: %i[show] do
    member do
      get :result
    end
    resources :favorites, only: %i[create destroy]
  end

  post '/callback' => 'linebot#callback'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
