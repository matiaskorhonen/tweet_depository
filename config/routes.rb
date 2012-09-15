TweetDepository::Application.routes.draw do
  root to: "statuses#index"
  match "/search", to: "statuses#search", as: :search
  match "auth/:provider/callback", to: "sessions#create"
  resource :sessions, only: [ :destroy ]
end
