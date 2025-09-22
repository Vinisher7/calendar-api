Rails.application.routes.draw do
  defaults format: :json do
  devise_for :users, path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
      namespace :api do
      namespace :v1 do
        resources :reservations
        resources :observations
        resources :payments
        get 'health', to: 'health#index'
      end
    end
  end
end
