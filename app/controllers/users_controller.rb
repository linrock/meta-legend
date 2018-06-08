class UsersController < ApplicationController

  def me
    unless current_user
      redirect_to account_login_url
      return
    end
    @user = current_user
  end

  def login
    redirect_to "/auth/bnet"
  end
end
