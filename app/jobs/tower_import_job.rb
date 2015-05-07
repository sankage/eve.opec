class TowerImportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    tower_import = XmlApi::TowerImport.new
    tower_import.execute
  end
end
