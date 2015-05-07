class Pilot < ActiveRecord::Base
  has_many :tower_stakes, dependent: :destroy
  has_many :towers, through: :tower_stakes
end
