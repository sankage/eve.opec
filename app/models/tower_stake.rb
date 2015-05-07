class TowerStake < ActiveRecord::Base
  belongs_to :pilot
  belongs_to :tower
end
