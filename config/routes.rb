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

  # forum home
  get "/forum"                     => "forum#index"
  get "/forum/general-discussion"  => "forum#general_discussion"
  get "/forum/legend-lounge"       => "forum#legend_lounge"

  # forum posts
  get "/forum/posts/new"           => "forum_posts#new"
  get "/forum/posts/:id"           => "forum_posts#show", as: "forum_post"
  post "/forum/posts"              => "forum_posts#create"
  post "/forum/posts/:id/comments" => "forum_comments#create", as: "forum_comments"

  # card routes
  # get "/cards"                     => "cards#index"
  get "/cards/:card"               => "cards#show"

  # player routes
  # get "/players"                   => "players#index"
  get "/players/:name"             => "players#show"

  # other game modes
  get "/arena"                     => "arena#index"
  get "/wild"                      => "wild#index"

  # user submission routes
  post "/submit_replays"           => "users#submit_replays"
  post "/replays.json"             => "submissions#create"
  post "/webhook"                  => "submissions#webhook"

  # user account routes
  get "/account"                   => "users#me"
  get "/account/login"             => "users#login"
  patch "/account"                 => "users#update"

  # login routes
  get "/auth/:provider/callback", to: "sessions#create"

  # catch-all routes for homepage
  constraints = {
    region: /(americas|europe|asia)/,
    rank: /top-1000?/
  }

  %w(
    :rank
    :region
    :region/:path
    :rank/:region
    :region/:path
    :rank/:path
    :rank/:region/:path
    :path
  ).each do |route|
    get route => "home#index", constraints: constraints
  end

  root to: "home#index"
end
