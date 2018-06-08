Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html
  get "/replays.json"     => "replays#index"
  get "/replays/:id.json" => "replays#show"
  get "/popular.json"     => "replays#popular"

  get "/account/sign_up"  => "users#sign_up"
  get "/account/log_in"   => "users#log_in"

  # get "/auth/:provider"
  get "/auth/:provider/callback", to: "sessions#create"

  get ":path" => "home#index"
  root to: "home#index"
end
