Rails.application.routes.draw do
  root to: "homepages#show"
  resource :dashboard, only: [:show]

  resource :jobvite_connection, only: [:edit, :update, :destroy]
  resource :icims_connection, only: [:edit, :update, :destroy]
  resource :greenhouse_connection, only: [:edit, :update, :destroy]
  resource :net_suite_connection, only: [:edit, :update, :destroy]

  resources :jobvite_imports, only: [:create]

  post(
    "/icims_candidate_imports/:api_key" => "icims_candidate_imports#create",
    as: :icims_candidate_imports,
  )
  post(
    "/greenhouse_candidate_imports/:secret_key" => "greenhouse_candidate_imports#create",
    as: :greenhouse_candidate_imports,
  )
  resources :icims_candidate_retry_imports, only: [:show]

  resource :session, only: [:new, :destroy]
  get "/session/oauth_callback", to: "sessions#oauth_callback", as: "session_oauth_callback"
end
