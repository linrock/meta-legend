Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html

  # JSON api endpoints
  get "/replays.json"              => "replays#index"
  get "/replays/:id.json"          => "replays#show"
  get "/replays/:id/likes.json"    => "replays#likes"
  post "/replays/like.json"        => "replays#like"
  get "/popular.json"              => "replays#popular"

  # user account routes
  get "/account"                   => "users#me"
  get "/account/login"             => "users#login"
  patch "/account"                 => "users#update"

  # forum posts
  get "/forum"                     => "forum#index"
  get "/forum/posts/new"           => "forum_posts#new"
  get "/forum/posts/:id"           => "forum_posts#show", as: "forum_post"

  # viewing a forum post
  post "/forum/posts"              => "forum_posts#create"
  post "/forum/posts/:id/comments" => "forum_comments#create", as: "forum_comments"

  # login routes
  get "/auth/:provider/callback", to: "sessions#create"

  # catch-all routes for homepage
  get ":path" => "home#index"
  root to: "home#index"
end
