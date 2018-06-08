class ApplicationController < ActionController::Base

  def current_user
    if session[:battletag].present?
      User.find_by(battletag: session[:battletag])
    end
  end
end
