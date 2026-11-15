require 'yaml'
require 'ap'

before = DocumentCategory.count

puts '---------'
puts 'Seeding document categories'
puts '---------'

file = File.read 'db/seeds/data/document_categories.yml'
list = YAML.safe_load(file)

list.each_with_index do |_item, i|
  item = OpenStruct.new(_item)

  puts "#{i + 1} - #{item.name}"

  props = OpenStruct.new(
    name: item.name,
    name_single: item.name_single,
    slug: item.slug,
    gist: item.gist,
    icon: item.icon,
    order: item.order
  )

  record = DocumentCategory.find_by(slug: item.slug)

  if record.nil?
    DocumentCategory.create!(props.to_h)
  else
    record.update!(props.to_h)
  end
end

puts '---------'
after = DocumentCategory.count
difference = after - before
puts "Before seeding, the database had #{before} document categories."
puts "After seeding, the database has #{after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
