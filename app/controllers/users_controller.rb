class UsersController < ApplicationController

  def me
    unless @user
      redirect_to account_login_path
      return
    end
  end

  def login
    if Rails.env.development?
      redirect_to "#{ENV['HTTPS_HOST']}/auth/bnet"
    else
      redirect_to "/auth/bnet"
    end
  end
end
