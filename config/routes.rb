Rails.application.routes.draw do
  resources :sauna_descriptions
  resources :invoices
  resources :contacts
  resources :reservations_invoices
  
  resources :reservations

  resources :users_contacts, only: %i[show create]

  resources :bookings, only: %i[index show create]

  resources :saunas do
    namespace :booking do
      resources :add_orders, only: %i[create]
    end
    resources :sauna_descriptions, only: %i[index create update]
    resources :billings
    resources :sauna_galleries
    get :get_contacts, on: :member
  end

  devise_for :users, controllers: {
    sessions: 'auth/sessions',
    registrations: 'auth/registrations',
    passwords: 'auth/passwords',
    confirmations: 'auth/confirmations'
  }

  resources :sauna_lists, only: %i[ index show ] do
    get :can_book, on: :member
    get :get_price, on: :member
    resources :reservations, only: %i[ index show create update ] do
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
