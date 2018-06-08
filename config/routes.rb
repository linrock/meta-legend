Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html
  get "/replays.json"     => "replays#index"
  get "/replays/:id.json" => "replays#show"
  get "/popular.json"     => "replays#popular"

  get "/account"          => "users#me"
  get "/account/login"    => "users#login"

  get "/forum"            => "forum#index"

  get "/auth/:provider/callback", to: "sessions#create"

  get ":path" => "home#index"
  root to: "home#index"
end
