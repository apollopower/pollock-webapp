Rails.application.routes.draw do

  root 'static_pages#home'

  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  resources :users, except: :index

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

  get '/pollock', to: 'pollock_pages#main'
  get '/pollock/analyze', to: 'pollock_pages#analyze'
  get '/pollock/new', to: 'pollock_pages#new'
  get '/pollock/show', to: 'pollock_pages#show'
  post '/pollock/show', to: 'pollock_pages#analyze'

end
