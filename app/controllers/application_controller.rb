class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :refresh_towers

  private

  def signed_in_user
    unless signed_in?
      flash[:danger] = "Please sign in."
      redirect_to root_path
    end
  end

  def admin_user
    unless signed_in_as_admin?
      flash[:danger] = "Unavailable action."
      redirect_to tower_path
    end
  end

  def refresh_towers
    last_update = Tower.order(updated_at: :desc).limit(1).pluck(:updated_at).first
    if last_update < 1.hour.ago
      TowerImportJob.perform_later
    end
  end
end
