Rails.application.routes.draw do
  root 'products#index'
  resources :products
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
