require 'yaml'
require 'byebug'
require 'ap'

after :product_families do
  before = Product.count

  puts '---------'
  puts 'Seeding products'
  puts '---------'

  file = File.read 'db/seeds/data/products.yml'
  data = YAML.safe_load(file)

  data.each_with_index do |_product, i|
    product = OpenStruct.new(_product)

    puts "#{i + 1} - #{product.name}"

    family = ProductFamily.find_by(slug: product.family)

    byebug if family.nil?

    props = OpenStruct.new(
      slug: product.slug,
      name: product.name,
      label: product.label,
      image_id: product.avatar,
      pitch: product.pitch,
      properties: product.properties,
      # code: product.code,

      public: product.public,
      # orderable: product.orderable || true,
      # featured: product.featured || false,
      # popular: product.popular || false,
      # new: product.new || false,

      main_family_id: family.id
    )

    record = Product.find_by(slug: product.slug)

    if record.nil?
      Product.create!(props.to_h)
    else
      record.update!(props.to_h)
    end
  end

  puts '---------'
  after = Product.count
  difference = after - before
  puts "Before seeding, the database had #{before} products."
  puts "After seeding, the database has #{after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
