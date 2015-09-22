# https://www.fuzzwork.co.uk/dump/latest/mapDenormalize.sql.bz3
require 'csv'
require 'progressbar'

desc "import mapDenormalize table"
task sdd_update: :environment do

  `curl -O https://www.fuzzwork.co.uk/dump/latest/mapDenormalize.csv.bz2`
  `bzip2 -d mapDenormalize.csv.bz2`
  row_count = `wc -l mapDenormalize.csv`.to_i
  Static::MapDenormalize.delete_all
  pbar = ProgressBar.new("processing", row_count-1)

  # Setup raw connection
  conn = ActiveRecord::Base.connection
  rc = conn.raw_connection
  rc.exec("COPY static_map_denormalizes (item_id, type_id, group_id, solar_system_id, constellation_id, region_id, orbit_id, x, y, z, radius, item_name, security, celestial_index, orbit_index) FROM STDIN WITH CSV")

  file = File.open('mapDenormalize.csv', 'r')
  file.readline # skip header row
  while !file.eof?
    # Add row to copy data
    rc.put_copy_data(file.readline)
    pbar.inc
  end

  # We are done adding copy data
  rc.put_copy_end

  # Display any error messages
  while res = rc.get_result
    if e_message = res.error_message
      p e_message
    end
  end
end
