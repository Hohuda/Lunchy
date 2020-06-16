Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users
  
  resources :users do
    resources :orders
  end
  resources :menu
  resources :victuals

end
