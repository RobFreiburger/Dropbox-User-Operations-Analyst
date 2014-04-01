require 'csv'
require 'date'

# import iso codes
iso_codes = Hash.new
CSV.foreach("iso3166.csv") do |row|
  iso_codes[row[0].downcase] = row[1]
end

# import and convert ticket data
tickets = Array.new
skip_first_row = true
CSV.foreach("rawdata.csv") do |row|
  unless skip_first_row
    time = DateTime.strptime(row[1], '%s')
    country = row[2]
  
    # Convert time to Excel readable
    time_string = time.strftime('%D %r')
  
    # Convert country code to full country name
    country_code = country.match(/country_(\w{2})/)
    unless country_code.nil?
      country = iso_codes[country_code[1].to_s]
    end
  
    tickets << [row[0].to_i, time_string, country]
  end
  
  skip_first_row = false
end

# write new csv
CSV.open("converted.csv", "wb") do |csv|
  tickets.each do |ticket|
    csv << ticket
  end
end