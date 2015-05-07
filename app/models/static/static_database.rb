module Static
  class StaticDatabase < ActiveRecord::Base
    self.abstract_class = true
    establish_connection :static_data_dump
  end
end
