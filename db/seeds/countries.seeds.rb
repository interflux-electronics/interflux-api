require 'json'
require 'ap'

count_before = Country.count

puts '---------'
puts 'Seeding countries'
puts '---------'

file = File.read 'db/seeds/data/countries.json'
data = JSON.parse(file)

data.each_with_index do |hash, i|
  country = OpenStruct.new(hash)

  puts "#{i} - Seeding #{country.name}"

  record = Country.find_by(two_letter_code: country.alpha_2_code)

  properties = OpenStruct.new(
    name_english: country.name,
    name_native: country.native_name,
    two_letter_code: country.alpha_2_code,
    three_letter_code: country.alpha_3_code,
    numeric_code: country.numeric_code,
    region: country.region,
    subregion: country.subregion,
    latitude: country.latlng[0] || -1,
    longitude: country.latlng[1] || -1,
    area: country.area.to_i || -1,
    population: country.population.to_i || -1,
    flag_url: country.flag,
    timezones: country.timezones.join(','),
    top_level_domains: country.top_level_domains.join(','),
    calling_codes: country.calling_codes.join(',')
  )

  if record.nil?
    Country.create!(properties.to_h)
  else
    record.update!(properties.to_h)
  end
end

puts '---------'
count_after = Country.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} country currencies."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
