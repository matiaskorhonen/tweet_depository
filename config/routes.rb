TweetDepository::Application.routes.draw do
  root to: "statuses#index"
  match "auth/:provider/callback", to: "sessions#create"
end
