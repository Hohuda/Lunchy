Rails.application.routes.draw do
  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'

  devise_for :users, controllers: {
    registrations: 'users/registrations', 
    sessions: 'users/sessions', 
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    confirmations: 'users/confirmations'
  }
  
  resources :victuals

  resources :users, only: [:index, :show] do
    member do
      get 'orders', as: :orders_for
    end
  end

  resources :orders do
    member do 
      get 'submit'
    end

    collection do
      get 'today'
      get 'for_day'
    end
  end

  resources :menus do
    collection do
      get 'for_day'
      get 'today'
    end
  end

  resources :categories, except: [:edit, :update, :destroy] do
    collection do
      get 'delete'
    end
  end
  
  post '/destroy_chosen_categories', to: 'categories#destroy'
end
