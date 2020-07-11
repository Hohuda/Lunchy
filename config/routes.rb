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
  
  get 'categories/delete'  # Not implemented 

  resources :victuals
  resources :users, only: [:index, :show]
  resources :orders do
    member do 
      get 'submit'
    end
    collection do
      get 'for_user', as: :user
      get 'today'
    end
  end
  resources :menus do
    collection do
      get 'today'
    end
  end
  resources :categories do
  end
end
