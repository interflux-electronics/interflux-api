require 'yaml'
require 'ap'

count_before = Feature.count

puts '---------'
puts 'Seeding features'
puts '---------'

file = File.read 'db/seeds/data/features.yml'
data = YAML.safe_load(file)

data.each_with_index do |_feature, i|
  feature = OpenStruct.new(_feature)

  puts "#{i + 1} - #{feature.text}"

  record = Feature.find_by(slug: feature.slug)

  properties = OpenStruct.new(
    slug: feature.slug,
    text: feature.text,
    icon: feature.icon,
    gist: feature.gist,
    category: feature.category,
    has_page: feature.has_page
  )

  if record.nil?
    Feature.create!(properties.to_h)
  else
    record.update!(properties.to_h)
  end
end

puts '---------'
count_after = Feature.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} features."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
