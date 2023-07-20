# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'application#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/dashboard', to: 'users#show'

  resources :discover, only: %i[index]
  
  resources :movies, only: %i[index show] do
    resources :viewing_parties, only: %i[new create]
  end
  # resources :users, only: %i[new create show] do
  #   resources :discover, only: %i[index]
  #   resources :movies, only: %i[index show] do
  #     resources :viewing_parties, only: %i[new create]
  #   end
  # end
end
