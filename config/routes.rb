Rails.application.routes.draw do

  resources :games, only: [:index]
  root to: 'home#index'
  get 'auth/slack/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/restricted', to: 'home#restricted'
end
