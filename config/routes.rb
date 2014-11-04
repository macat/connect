Rails.application.routes.draw do
  root to: "homepages#show"
  resource :dashboard, only: [:show]
  resource :jobvite_connection, only: [:edit, :update]
  resource :session, only: [:new, :destroy]
  get "/session/oauth_callback", to: "sessions#oauth_callback", as: "session_oauth_callback"
end
