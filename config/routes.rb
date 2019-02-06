Rails.application.routes.draw do
  devise_for :users, controllers: {:registrations => "registrations"}
  as :user do
    get "/register", to: "registrations#new", as: "register"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'orders#index'
  get '/search_customer', to: 'customers#search'
  resources :users, only: %i(new create)

  resources :orders, only: %i(index new create show) do
    get 'cancel_form', on: :member
    post 'cancel', on: :member
    post 'approve', on: :member
  end

  resources :individuals, only: %i[show new create] do
    get 'search', on: :collection
  end
  resources :companies, only: %i[show new create] do
    get 'search', on: :collection
  end
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :orders, only: %i(index) do
      end
    end
  end

end
