class Tower < ActiveRecord::Base
  TYPE_MAP = {
    20060 => { name: "Amarr Control Tower Small", size: :small, consumption: 10 },
    20059 => { name: "Amarr Control Tower Medium", size: :medium, consumption: 20 },
    12235 => { name: "Amarr Control Tower", size: :large, consumption: 40 },
    27610 => { name: "Angel Control Tower Small", size: :small, consumption: 9 },
    27607 => { name: "Angel Control Tower Medium", size: :medium, consumption: 18 },
    27539 => { name: "Angel Control Tower", size: :large, consumption: 36 },
    27592 => { name: "Blood Control Tower Small", size: :small, consumption: 9 },
    27589 => { name: "Blood Control Tower Medium", size: :medium, consumption: 18 },
    27530 => { name: "Blood Control Tower", size: :large, consumption: 36 },
    20062 => { name: "Caldari Control Tower Small", size: :small, consumption: 10 },
    20061 => { name: "Caldari Control Tower Medium", size: :medium, consumption: 20 },
    16213 => { name: "Caldari Control Tower", size: :large, consumption: 40 },
    27594 => { name: "Dark Blood Control Tower Small", size: :small, consumption: 8 },
    27591 => { name: "Dark Blood Control Tower Medium", size: :medium, consumption: 16 },
    27532 => { name: "Dark Blood Control Tower", size: :large, consumption: 32 },
    27612 => { name: "Domination Control Tower Small", size: :small, consumption: 8 },
    27609 => { name: "Domination Control Tower Medium", size: :medium, consumption: 16 },
    27540 => { name: "Domination Control Tower", size: :large, consumption: 32 },
    27600 => { name: "Dread Guristas Control Tower Small", size: :small, consumption: 8 },
    27597 => { name: "Dread Guristas Control Tower Medium", size: :medium, consumption: 16 },
    27535 => { name: "Dread Guristas Control Tower", size: :large, consumption: 32 },
    20064 => { name: "Gallente Control Tower Small", size: :small, consumption: 10 },
    20063 => { name: "Gallente Control Tower Medium", size: :medium, consumption: 20 },
    12236 => { name: "Gallente Control Tower", size: :large, consumption: 40 },
    27598 => { name: "Guristas Control Tower Small", size: :small, consumption: 9 },
    27595 => { name: "Guristas Control Tower Medium", size: :medium, consumption: 18 },
    27533 => { name: "Guristas Control Tower", size: :large, consumption: 36 },
    20066 => { name: "Minmatar Control Tower Small", size: :small, consumption: 10 },
    20065 => { name: "Minmatar Control Tower Medium", size: :medium, consumption: 20 },
    16214 => { name: "Minmatar Control Tower", size: :large, consumption: 40 },
    27784 => { name: "Sansha Control Tower Small", size: :small, consumption: 9 },
    27782 => { name: "Sansha Control Tower Medium", size: :medium, consumption: 18 },
    27780 => { name: "Sansha Control Tower", size: :large, consumption: 36 },
    27604 => { name: "Serpentis Control Tower Small", size: :small, consumption: 9 },
    27601 => { name: "Serpentis Control Tower Medium", size: :medium, consumption: 18 },
    27536 => { name: "Serpentis Control Tower", size: :large, consumption: 36 },
    27606 => { name: "Shadow Control Tower Small", size: :small, consumption: 8 },
    27603 => { name: "Shadow Control Tower Medium", size: :medium, consumption: 16 },
    27538 => { name: "Shadow Control Tower", size: :large, consumption: 32 },
    27790 => { name: "True Sansha Control Tower Small", size: :small, consumption: 8 },
    27788 => { name: "True Sansha Control Tower Medium", size: :medium, consumption: 16 },
    27786 => { name: "True Sansha Control Tower", size: :large, consumption: 32 },
  }
  STRONTIUM_CONSUMPTION = {
    small: 100,
    medium: 200,
    large: 400
  }

  belongs_to :moon
  has_many :tower_stakes, dependent: :destroy
  has_many :pilots, through: :tower_stakes

  enum state: [ :unanchored, :offline, :onlining, :reinforced, :online ]

  def hours_til_empty
    charter_time = 1440 # 60 days * 24 hours / day
    charter_time = (charters.to_f - hours_since_update) if charters != nil
    fuel_block_time = ((fuel_blocks.to_f / consumption_rate) - hours_since_update)
    if charter_time > fuel_block_time
      fuel_block_time
    else
      charter_time
    end
  end

  def time_til_empty
    return "--" unless online?
    seconds_to_units(hours_til_empty * 3600)
  end

  def type
    details[:name]
  end

  def reinforced_hours_til_empty
    (strontium.to_f / strontium_rate).round(2)
  end

  def to_params
    item_id
  end

  private

  def details
    @details ||= TYPE_MAP[type_id]
  end

  def consumption_rate
    details[:consumption]
  end

  def hours_since_update
    (Time.now - updated_at) / 3600
  end

  def strontium_rate
    STRONTIUM_CONSUMPTION[details[:size]]
  end

  def seconds_to_units(seconds)
    '%d&nbsp;days, %d&nbsp;hours, %d&nbsp;minutes' %
      # the .reverse lets us put the larger units first for readability
      [24,60,60].reverse.inject([seconds]) { |result, unitsize|
        result[0,0] = result.shift.divmod(unitsize)
        result
      }
  end
end
