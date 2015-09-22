desc "Import Tower and Members from EVE API"
task tower_import: :environment do
  TowerImportJob.perform_now
end
