Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :customers
  root to: 'orders#index'

  resources :orders, only: %i(index new create show)
end
