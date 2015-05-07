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
      EAAL::API.new(ENV["CORP_API_ID"], ENV["CORP_API_VCODE"], "eve")
    end
  end
end
