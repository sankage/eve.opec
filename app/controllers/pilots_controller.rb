class PilotsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :admin_user, only: [:create, :destroy]

  def create
    @tower = Tower.find(params[:tower_id])
    pilot = Pilot.where(pilot_params).first_or_create do |p|
      character_id = XmlApi::CharacterIDLookup.new(pilot_params).id
      fail XmlApi::Error, "Character doesnt exist" if character_id == 0;
      p.character_id = character_id
    end

    pilot.tower_stakes.create!(tower: @tower)

    redirect_to tower_path(@tower.item_id)
  rescue XmlApi::Error
    @pilot = Pilot.new(pilot_params)
    @pilot.errors.add(:name, "This name doesn't exist.")
    render "towers/show"
  end

  def destroy
    pilot = Pilot.find_by(character_id: params[:id])
    tower = Tower.find_by(item_id: params[:tower_id])
    pilot.tower_stakes.find_by(tower_id: tower.id).destroy
    redirect_to tower_path(tower.item_id)
  end

  private

  def pilot_params
    params.require(:pilot).permit(:name)
  end
end
