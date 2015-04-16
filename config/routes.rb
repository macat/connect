Rails.application.routes.draw do
  root to: "homepages#show"
  resource :dashboard, only: [:show]

  resource :jobvite_connection, only: [:edit, :update, :destroy]
  resource :icims_connection, only: [:edit, :update, :destroy]

  resources :jobvite_imports, only: [:create]
  resources :icims_imports, only: [:create]

  resources :icims_candidate_imports, only: [:create]
  resources :icims_candidate_retry_imports, only: [:show]

  resource :session, only: [:new, :destroy]
  get "/session/oauth_callback", to: "sessions#oauth_callback", as: "session_oauth_callback"
end
