Rails.application.routes.draw do
  get 'game/show'

  root to: 'home#index'
  resource :lobby, only: [:show]

  get 'auth/slack/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'

  get '/restricted', to: 'home#restricted'

  get '/game', to: 'game#show'
end
