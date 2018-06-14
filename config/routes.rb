Rails.application.routes.draw do
  # see http://guides.rubyonrails.org/routing.html

  # JSON api endpoints
  get "/replays.json"              => "replays#index"
  get "/popular.json"              => "replays#popular"

  post "/replays/like.json"        => "replay_likes#create"
  post "/replays/get_likes.json"   => "replay_likes#likes_batch"

  # header links
  get "/decks"                     => "decks#index"
  get "/decks/top-1000"            => "decks#index"
  get "/decks/top-100"             => "decks#index"

  # user account routes
  get "/account"                   => "users#me"
  get "/account/login"             => "users#login"
  patch "/account"                 => "users#update"

  # user submission routes
  post "/submit_replays"           => "users#submit_replays"

  # forum home
  get "/forum"                     => "forum#index"
  get "/forum/general-discussion"  => "forum#general_discussion"
  get "/forum/legend-lounge"       => "forum#legend_lounge"

  # forum posts
  get "/forum/posts/new"           => "forum_posts#new"
  get "/forum/posts/:id"           => "forum_posts#show", as: "forum_post"
  post "/forum/posts"              => "forum_posts#create"
  post "/forum/posts/:id/comments" => "forum_comments#create", as: "forum_comments"

  # login routes
  get "/auth/:provider/callback", to: "sessions#create"

  # catch-all routes for homepage
  get ":path" => "home#index"
  root to: "home#index"
end
