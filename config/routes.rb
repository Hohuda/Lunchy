Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations', 
    sessions: 'users/sessions', 
    passwords: 'users/password',
    unlocks: 'users/unlocks',
    confirmations: 'users/confirmations',
  }
  
  get 'orders/orders_of_user'
  get 'menus/today_menus'
  get 'categories/delete'


  resources :searches, only: [:update]
  resources :users
  resources :orders 
  resources :menus
  resources :victuals
  resources :categories



end
