Rails.application.routes.draw do
  root 'pages#index'
  get 'products/update_sheets', to: 'products#update_sheets', as: 'update_sheets'
  resources :products


  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
