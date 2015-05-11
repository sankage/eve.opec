class TowerStakesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :admin_user, only: [:create, :destroy]

  def create
    @tower = Tower.find(params[:tower_id])
    pilot = Pilot.where(name: params[:pilot_name]).first_or_create do |p|
      character_id = XmlApi::CharacterIDLookup.new(name: params[:pilot_name]).id
      fail XmlApi::Error, "Character doesnt exist" if character_id == 0;
      p.character_id = character_id
    end

    @tower.tower_stakes.create!(pilot: pilot)

    redirect_to tower_path(@tower.item_id)
  rescue XmlApi::Error
    @tower_stake = TowerStake.new
    @tower_stake.errors.add(:pilot, "This name doesn't exist.")
    render "towers/show"
  end

  def destroy
    tower = Tower.find_by(item_id: params[:tower_id])
    tower.tower_stakes.find_by(id: params[:id]).destroy
    redirect_to tower_path(tower.item_id)
  end

end
