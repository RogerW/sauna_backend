Rails.application.routes.draw do
  if Rails.env.development? or Rails.env.test?
    mount Rswag::Api::Engine => '/api-docs'
  end
  resources :sauna_descriptions
  resources :invoices
  resources :contacts
  resources :user_orders, only: %i[index show]

  resources :reservations

  resources :users_contacts, only: %i[show create]

  resources :bookings, only: %i[index show create]

  # resources :apidocs, only: [:index]

  get '/addresses/search', to: 'addresses#search'
  get '/addresses/full_address', to: 'addresses#full_address'
  get '/addresses/search_city', to: 'addresses#search_city'

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

  devise_scope :users do
    get 'users/sign_in' => 'auth/sessions#new'
  end

  get 'users/vkontakte' => 'auth/oauth#vkontakte'

  resources :sauna_lists, only: %i[index show] do
    get :can_book, on: :member
    get :get_price, on: :member
    resources :reservations, only: %i[index show create update] do
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
