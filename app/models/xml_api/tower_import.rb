require "eaal"

module XmlApi
  class TowerImport
    attr_reader :notifier

    def initialize(notifier: Notifier.new)
      @notifier = notifier
    end

    def execute
      remove_old_towers
      add_or_update_towers
    end

    private

    def remove_old_towers
      starbase_item_ids = starbases.map(&:itemID).map(&:to_i)
      existing_tower_ids = Tower.pluck(:item_id)
      removed_tower_ids = existing_tower_ids - starbase_item_ids
      Tower.where(item_id: removed_tower_ids).destroy_all
    end

    def add_or_update_towers
      starbases.map do |pos|
        tower = find_or_initialize_tower(pos)
        no_name = ->{ OpenStruct.new(itemName: '<not set>') }
        tower.name = tower_names.detect(no_name) { |p| p.itemID.to_i == pos.itemID.to_i }.itemName
        tower.moon = find_or_create_moon(pos) if tower.moon.nil?
        tower.state = pos.state.to_i
        details = tower_api_details(tower.item_id)
        tower.secure = details.generalSettings.allowCorporationMembers.to_i == 0 &&
                       details.generalSettings.allowAllianceMembers.to_i == 0
        tower = add_fuel_to(tower, details.fuel)

        tower.save!

        notifier.check_for_notification(tower)

      end
    end

    def starbases
      @starbases ||= begin
        pos_list = api.StarbaseList
        pos_list.starbases
      end
    end

    def tower_names
      @tower_names ||= begin
        tower_ids = starbases.map(&:itemID)
        api.Locations(ids: tower_ids.join(",")).locations
      end
    end

    def find_or_initialize_tower(pos)
      Tower.where(item_id: pos.itemID.to_i).first_or_initialize do |t|
        t.type_id = pos.typeID.to_i
      end
    end

    def find_or_create_moon(pos)
      # Find or create solar system
      solar_system = System.where(item_id: pos.locationID.to_i).first_or_create do |s|
        s.name = static_map_lookup_name(pos.locationID.to_i)
      end
      # Find or create moon
      Moon.where(item_id: pos.moonID.to_i).first_or_create do |m|
        m.system = solar_system
        moon_details = static_moon_info(pos.moonID.to_i)
        m.name = moon_details[:name]
        m.planet = moon_details[:planet]
        m.orbit = moon_details[:orbit]
      end
    end

    def tower_api_details(tower_id)
      @details ||= {}
      @details[tower_id] ||= api.StarbaseDetail(itemID: tower_id)
    end

    def add_fuel_to(tower, fuel_objects)
      fuel_objects.each do |fuel|
        # 16275 is the itemID for Strontium Clathrates
        if fuel.typeID.to_i == 16275
          tower.strontium = fuel.quantity
        # these ids are for starbase charters
        elsif [24592, 24593, 24594, 24595, 24596, 24597].include? fuel.typeID.to_i
          tower.charters = fuel.quantity
        else
          tower.fuel_blocks = fuel.quantity
        end
      end
      tower
    end

    def static_map_lookup_name(id)
      denormalized_lookup(id).itemName
    end

    def static_moon_info(id)
      result = denormalized_lookup(id)
      { name: result.itemName, planet: result.celestialIndex, orbit: result.orbitIndex }
    end

    def denormalized_lookup(id)
      # SELECT * FROM mapDenormalize WHERE mapDenormalize.itemID = 30000125
      Static::MapDenormalize.find_by(itemID: id)
    end

    def api
      EAAL::API.new(Rails.application.secrets.xml_api_corp_id, Rails.application.secrets.xml_api_corp_vcode, "corp")
    end
  end
end
