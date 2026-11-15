require 'yaml'
require 'ap'

count_before = Event.count

puts '---------'
puts 'Seeding events'
puts '---------'

file = File.read 'db/seeds/data/events.yml'
data = YAML.safe_load(file)

data.each_with_index do |a, i|
  b = OpenStruct.new(a)

  puts "#{i} - #{b.name}"

  record = Event.find_by(name: b.name, dates: b.dates)

  properties = OpenStruct.new(
    name: b.name,
    city: b.city,
    country_id: b.country_id,
    description: b.description,
    dates: b.dates
  )

  if record.nil?
    Event.create!(properties.to_h)
  else
    record.update!(properties.to_h)
  end
end

puts '---------'
count_after = Event.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} records."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
