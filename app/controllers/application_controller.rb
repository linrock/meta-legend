class ApplicationController < ActionController::Base
  before_action :set_user

  def set_user
    if session[:battletag].present?
      @user = User.find_by(battletag: session[:battletag])
    end
  end
end
