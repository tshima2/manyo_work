Rails.application.routes.draw do
#  get 'sessions/new'
  get '/', to: 'tasks#index'      
  resources :tasks do
    collection do
      post :confirm
    end
  end
  resources :users
  resource :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    resources :users
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
