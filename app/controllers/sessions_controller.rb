class SessionsController < ApplicationController
  def create
    if User.where(uid: env["omniauth.auth"]["uid"]).exists? || !User.any?
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Signed in."
    else
      redirect_to root_url, notice: "You are not allowed to sign in here."
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out."
  end
end
