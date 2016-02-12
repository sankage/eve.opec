Rails.application.routes.draw do
  resources :towers, only: [:index, :show, :update] do
    resources :tower_stakes, only: [:create, :destroy]
  end

  namespace :admin do
    resources :pilots, only: [:index] do
      patch 'toggle', on: :member
    end
  end

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
