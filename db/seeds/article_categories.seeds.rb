require 'yaml'
require 'ap'

before = ArticleCategory.count

puts '---------'
puts 'Seeding article categories'
puts '---------'

file = File.read 'db/seeds/data/article_categories.yml'
list = YAML.safe_load(file)

list.each_with_index do |_item, i|
  item = OpenStruct.new(_item)

  puts "#{i + 1} - #{item.name}"

  props = OpenStruct.new(
    name: item.name,
    slug: item.slug
  )

  record = ArticleCategory.find_by(slug: item.slug)

  if record.nil?
    ArticleCategory.create!(props.to_h)
  else
    record.update!(props.to_h)
  end
end

puts '---------'
after = ArticleCategory.count
difference = after - before
puts "Before seeding, the database had #{before} article categories."
puts "After seeding, the database has #{after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
