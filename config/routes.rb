Rails.application.routes.draw do
  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'

  devise_for :users, controllers: {
    registrations: 'users/registrations', 
    sessions: 'users/sessions', 
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    confirmations: 'users/confirmations',
  }
  
  get 'orders/for_user'
  get 'menus/today_menus'
  get 'categories/delete'

  resources :victuals
  resources :users
  resources :orders
  resources :menus
  resources :categories
end
