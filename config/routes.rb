Rails.application.routes.draw do
  get "clients/new"
  root "blog_posts#index"
  resources :blog_posts
  resources :clients

  resources :blog_posts do
    resources :comments, shallow: true
  end

  get "ब्लॉग", to: "blog_posts#index"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :note_books
  resources :users, only: [ :new, :create ]
  namespace :admin do
    resources :note_books do
      member do
        get :download
      end
    end
  end

  namespace :admin do
    root "note_books#index"
  end

  resources :notebooks do
    collection do
      post :upload_csv
    end
  end
end
