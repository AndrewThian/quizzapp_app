Rails.application.routes.draw do

  root 'home#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'logout' => 'sessions#destroy', via: [:get, :delete]

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  resources :users, only: [:edit, :update, :show]

  resources :categories, only: [:index, :show] do |f|
    resources :questions, only: [:index, :update]
    resources :highscore, only: [:update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
