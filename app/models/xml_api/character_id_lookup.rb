require "eaal"

module XmlApi
  class CharacterIDLookup
    def initialize(options)
      @pilot_name = options.fetch(:name)
    end

    def id
      api.CharacterID(names: @pilot_name).characters.first.characterID.to_i
    end

    private

    def api
      EAAL::API.new(Rails.application.secrets.xml_api_corp_id, Rails.application.secrets.xml_api_corp_vcode, "eve")
    end
  end
end
