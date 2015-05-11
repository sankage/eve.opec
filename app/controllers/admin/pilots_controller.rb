module Admin
  class PilotsController < ApplicationController
    before_action :signed_in_user, only: [:index, :toggle]
    before_action :admin_user, only: [:index, :toggle]

    def index
      @pilots = Pilot.includes(:towers).order(:name)
    end

    def toggle
      @pilot = Pilot.find_by(character_id: params[:id])
      @pilot.toggle!(:admin)
      redirect_to admin_pilots_path
    end
  end
end
