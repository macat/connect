Rails.application.routes.draw do
  root to: "homepages#show"
  resource :dashboard, only: [:show]

  resources :jobvite_imports, only: [:create]

  resource :net_suite_exports, only: [:create]

  post(
    "/icims_candidate_imports/:api_key",
    to: "icims_candidate_imports#create",
    as: :icims_candidate_imports,
  )

  post(
    "/greenhouse_candidate_imports/:secret_key",
    to: "greenhouse_candidate_imports#create",
    as: :greenhouse_candidate_imports,
  )

  resources :icims_candidate_retry_imports, only: [:show]
  resource :session, only: [:new, :destroy]

  get(
    "/session/oauth_callback",
    to: "sessions#oauth_callback",
    as: "session_oauth_callback"
  )

  get(
    "/connections/:form_type/new",
    to: "connections#new",
    as: "new_connection"
  )

  post(
    "/connections/:form_type",
    to: "connections#create",
    as: "connection"
  )

  delete(
    "/connections/:form_type",
    to: "connections#destroy",
    as: "destroy_connections"
  )
end
