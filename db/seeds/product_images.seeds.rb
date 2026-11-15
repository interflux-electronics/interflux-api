puts '---------'
puts 'Seeding product images'
puts '---------'

count_before = ProductImage.count

Image.all.each do |image|
  next unless image.path.start_with?('images/products/')

  slug = image.path.split('/').third
  product = Product.find_by(slug: slug)

  debugger if product.nil?

  props = OpenStruct.new(
    product_id: product.id,
    image_id: image.id,
    public: true,
    rank: 999
  )

  record = ProductImage.find_by(product_id: product.id, image_id: image.id)

  if record.nil?
    ProductImage.create!(props.to_h)
  else
    record.update!(props.to_h)
  end
end

count_after = ProductImage.count

puts "Before: #{count_before}"
puts "After: #{count_after}"
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
