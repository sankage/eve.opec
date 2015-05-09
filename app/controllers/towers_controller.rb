class TowersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show]
  before_action :admin_user, only: [:import]

  def index
    if signed_in_as_admin?
      @towers = Tower.includes(:moon).order(state: :desc, name: :asc)
    else
      @towers = current_user.towers.includes(:moon).order(state: :desc, name: :asc)
    end
  end

  def import
    TowerImportJob.perform_later
    redirect_to towers_path
  end

  def show
    @tower = Tower.find_by(item_id: params[:id])
    unless signed_in_as_admin? || current_user.towers.include?(@tower)
      flash[:alert] = "You do not have access to this tower."
      redirect_to towers_path
    end
    @pilots = Pilot.order(:name)
    @pilot = Pilot.new
  end
end
