class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :public_timeline?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    unless current_user
      redirect_to "/auth/twitter"
    end
  end

  def public_timeline?
    ENV["PUBLIC_TIMELINE"].to_s =~ /\Atrue\z/i
  end

  helper_method :current_user
end
