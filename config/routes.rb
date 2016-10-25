Rails.application.routes.draw do
  root to: 'home#index'

  get 'auth/slack/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'

  get '/restricted', to: 'home#restricted'
end
