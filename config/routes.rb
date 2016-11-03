Rails.application.routes.draw do
  get 'lobbies/show'

  root to: 'home#index'
  resource :lobby, only: [:show]

  get 'auth/slack/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'

  get '/restricted', to: 'home#restricted'
end
