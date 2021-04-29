Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :admins
      get 'admins/new'
      get 'admins/show'
      get 'login' => 'sessions#new'
      post 'login' => 'sessions#create'
      delete 'logout' => 'sessions#destroy'
      get 'user_in' => 'sessions#user_in'
      post 'admins/signup' => 'admins#create'
    end
  end
end
