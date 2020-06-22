Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users
  get 'orders/orders_of_user'
  get 'menus/today_menus'
  resources :users
  resources :orders 
  resources :menus
  resources :victuals


end
