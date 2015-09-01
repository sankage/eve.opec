class TowersController < ApplicationController
  before_action :signed_in_user, only: [:index, :show]
  before_action :admin_user, only: [:import]

  def index
    if signed_in_as_admin?
      @towers = Tower.includes(:moon).order(state: :desc, name: :asc)
    else
      @towers = current_user.towers.includes(:moon).order(state: :desc, name: :asc)
    end
    @last_update = Tower.order(updated_at: :desc).limit(1).pluck(:updated_at).first
  end

  def show
    @tower = Tower.find_by(item_id: params[:id])
    unless signed_in_as_admin? || current_user.towers.include?(@tower)
      flash[:alert] = "You do not have access to this tower."
      redirect_to towers_path
    end
    @pilots = Pilot.order(:name)
    @tower_stake = TowerStake.new
  end
end
