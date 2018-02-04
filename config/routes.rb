Rails.application.routes.draw do
  root to: 'drawings#index'

  resources :drawings do
    resources :production_files
  end

  resources :formats
  resources :sessions, only: [:create, :new, :destroy]

  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
end
