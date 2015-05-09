class TowerImportJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    tower_import = XmlApi::TowerImport.new
    tower_import.execute

    member_import = XmlApi::MemberImport.new
    member_import.execute
  end
end
