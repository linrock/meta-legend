Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html
  get "/replays.json"     => "replays#index"
  get "/replays/:id.json" => "replays#show"
  get "/popular.json"     => "replays#popular"

  get "/account"          => "users#me"
  get "/account/login"    => "users#login"

  get "/forum"            => "forum#index"
  get "/forum/posts/new"  => "forum_posts#new"
  get "/forum/posts/:id"  => "forum_posts#show", as: "forum_post"
  post "/forum/posts"     => "forum_posts#create"

  get "/auth/:provider/callback", to: "sessions#create"

  get ":path" => "home#index"
  root to: "home#index"
end
