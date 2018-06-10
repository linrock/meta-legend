class UsersController < ApplicationController

  def me
    unless @user
      redirect_to account_login_path
      return
    end
  end

  def update
    @user.assign_attributes user_params
    if @user.valid?
      @user.save!
    else
      flash[:notice] = (["Error updating account"] + @user.errors.full_messages).join("\n\n")
    end
    if Rails.env.development?
      redirect_to "#{ENV['HTTPS_HOST']}/account"
    else
      redirect_to account_path
    end
  end

  def login
    if Rails.env.development?
      redirect_to "#{ENV['HTTPS_HOST']}/auth/bnet"
    else
      redirect_to "/auth/bnet"
    end
  end

  private

  def user_params
    params.require(:user).permit(:forum_username, :twitch_username, :region)
  end
end
