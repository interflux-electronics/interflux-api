require 'yaml'
require 'ap'

count_before = Use.count

puts '---------'
puts 'Seeding uses'
puts '---------'

file = File.read 'db/seeds/data/uses.yml'
data = YAML.safe_load(file)
images = Image.all

data.each_with_index do |u, i|
  use = OpenStruct.new(u)

  puts "#{i + 1} - #{use.text}"

  record = Use.find_by(slug: use.slug)
  image = images.filter { |x| x.path.ends_with? use.icon } .first if use.icon.present?
  image_id = image.present? ? image.id : nil

  properties = OpenStruct.new(
    slug: use.slug,
    text: use.text,
    gist: use.gist,
    image_id: image_id
  )

  if record.nil?
    Use.create!(properties.to_h)
  else
    record.update!(properties.to_h)
  end
end

puts '---------'
count_after = Use.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} uses."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
