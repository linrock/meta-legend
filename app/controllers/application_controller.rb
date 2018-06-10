class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user
    if session[:user_id].present?
      @user = User.find_by(id: session[:user_id])
    end
  end
end
