TweetDepository::Application.routes.draw do
  root to: "pages#home"
  match "auth/:provider/callback", to: "sessions#create"
end
