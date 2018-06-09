class UsersController < ApplicationController

  def me
    unless @user
      redirect_to account_login_url
      return
    end
  end

  def login
    redirect_to "/auth/bnet"
  end
end
