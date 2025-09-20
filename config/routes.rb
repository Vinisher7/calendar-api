Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :reservations
      resources :observations
      resources :payments
    end
  end
end
