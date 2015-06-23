module Static
  class MapDenormalize < StaticDatabase
    self.table_name = "mapDenormalize"
    self.primary_key = "itemID"
    # include ReadOnlyRecord

    alias_attribute :name, :itemName
    alias_attribute :group_id, :groupID
  end
end
