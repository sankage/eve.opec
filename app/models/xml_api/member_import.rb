require "eaal"

module XmlApi
  class MemberImport
    def execute
      members_to_add.each do |member|
        Pilot.create(character_id: member.characterID.to_i, name: member.name)
      end

      pilots_to_remove.each do |pilot|
        pilot.destroy
      end
    end

    private

    def members
      @members ||= api.MemberTracking.members
    end

    def member_ids
      members.map(&:characterID).map(&:to_i)
    end

    def pilot_ids
      Pilot.pluck(:character_id)
    end

    def members_to_add
      member_ids_to_add = member_ids - pilot_ids
      members.select { |m| member_ids_to_add.include?(m.characterID.to_i) }
    end

    def pilots_to_remove
      pilot_ids_to_remove = pilot_ids - member_ids
      Pilot.where(character_id: pilot_ids_to_remove)
    end

    def api
      EAAL::API.new(Rails.application.secrets.xml_api_corp_id, Rails.application.secrets.xml_api_corp_vcode, "corp")
    end
  end
end
