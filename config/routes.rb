TweetDepository::Application.routes.draw do
  root to: "statuses#index"
  match"/:month", to: "statuses#index", as: :statuses_for_month, constraints: { month: /\d{4}-\d{2}/ }
  match "/search", to: "statuses#search", as: :search
  match "auth/:provider/callback", to: "sessions#create"
  resource :sessions, only: [ :destroy ]
end
