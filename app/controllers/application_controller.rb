class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  NotAuthenticated = Class.new(StandardError)

  rescue_from NotAuthenticated do
    flash[:notice] = 'Access denied'
    redirect_to new_session_path
  end

  def require_admin!
    session[:current_user] || raise(NotAuthenticated)
  end
end
