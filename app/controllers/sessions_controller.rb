class SessionsController < ApplicationController

  def create
    user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = user.id
    if Rails.env.development?
      redirect_to "#{ENV["HTTPS_HOST"]}/account"
    else
      redirect_to "/account"
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
