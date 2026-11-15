require 'yaml'
require 'ap'

count_before = Container.count

puts '---------'
puts 'Seeding containers'
puts '---------'

file = File.read 'db/seeds/data/containers.yml'
data = YAML.safe_load(file)

data.each_with_index do |_container, i|
  container = OpenStruct.new(_container)

  puts "#{i} - #{container.name}"

  record = Container.find_by(name: container.name)

  properties = OpenStruct.new(
    name: container.name
  )

  if record.nil?
    Container.create!(properties.to_h)
  else
    record.update!(properties.to_h)
  end
end

puts '---------'
count_after = Container.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} containers."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
