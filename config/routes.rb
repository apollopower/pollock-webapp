Rails.application.routes.draw do

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

  get '/pollock', to: 'pollock_pages#index'
  get '/pollock/new', to: 'pollock_pages#new'
  post '/pollock/new', to: 'pollock_pages#create'
  get '/pollock/show', to: 'pollock_pages#show'

end
