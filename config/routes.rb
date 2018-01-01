Rails.application.routes.draw do
  root to: 'drawings#index'

  resources :drawings
end
