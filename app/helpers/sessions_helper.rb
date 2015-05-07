module SessionsHelper
  # Logs in the given user.
  def sign_in(pilot)
    session[:pilot_id] = pilot.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= Pilot.find_by(id: session[:pilot_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def signed_in?
    !current_user.nil?
  end

  def signed_in_as_admin?
    current_user && current_user.admin?
  end

  def sign_out
    session.delete(:pilot_id)
    @current_user = nil
  end
end
