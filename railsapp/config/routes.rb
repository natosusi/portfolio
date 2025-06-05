Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new'
    get 'users/sign_out', to: 'users/sessions#destroy'
  end  

  resources :users, :lendings
  get  'books/search', to: 'books#search', as: :search_books
  post 'books/search', to: 'books#search'
  resources :books, only: [:index, :create,:show] do
    resources :likes, only: [:create,:destroy]
  end
  resources :reviews, only: [:create]
  resources :notification, only: [:index]
  get "/" => "home#top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
