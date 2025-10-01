Rails.application.routes.draw do
  root 'home#index'
  post 'suggest', to: 'suggests#create', as: :suggest

  devise_for :users

  resources :users, only: [] do
    collection do
      get :line_link
    end
  end

  resources :recipes, only: %i[show] do
    member do
      get :result
    end
    resources :favorites, only: %i[create destroy]
  end

  post '/callback' => 'linebot#callback'

  get "up" => "rails/health#show", as: :rails_health_check

end
