class SessionsController < ApplicationController
  def new
    redirect_to '/auth/evesso'
  end

  def create
    auth = request.env['omniauth.auth']
    byebug
    pilot = Pilot.find_by(character_id: auth['uid'])
    if pilot.nil?
      flash[:alert] = "You are not registered."
    else
      sign_in pilot
    end

    redirect_to root_path
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_path
  end

  def failure
    flash[:alert] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url
  end
end
