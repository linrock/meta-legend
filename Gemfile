source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'puma', '~> 3.11'
gem 'eye', require: false
gem 'bugsnag'

# persistence
gem 'pg', '>= 0.18', '< 2.0'
gem 'dalli', '~> 2.7'
gem 'sidekiq'

# business logic
gem 'omniauth-bnet'
gem 'nokogiri', '>= 1.8'

# assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'mini_racer', platforms: :ruby
gem 'webpacker'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dotenv-rails'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry'
end

group :development, :test do
  gem 'rspec-rails'
end
