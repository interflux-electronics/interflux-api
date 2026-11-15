after :products, :qualities do
  count_before = ProductQuality.count

  puts '---------'
  puts 'Seeding product qualities'
  puts '---------'

  file = File.read 'db/seeds/data/products.yml'
  data = YAML.safe_load(file)

  data.each_with_index do |x, i|
    product = OpenStruct.new(x)
    counter = i + 1
    spaces = ' ' * counter.to_s.length

    puts "#{counter} - #{product.name}"

    product_record = Product.find(product.slug)
    debugger if product_record.nil?

    next if product.qualities.nil?

    puts "#{spaces}   Qualities:"

    product.qualities.each do |slug|
      puts "#{spaces}   - #{slug}"

      quality = Quality.find(slug)

      next if quality.nil?

      properties = OpenStruct.new(
        product_id: product_record.id,
        quality_id: quality.id
      )

      relation_record = ProductQuality.where(product_id: product_record.id).where(quality_id: quality.id).first

      if relation_record.nil?
        ProductQuality.create!(properties.to_h)
      else
        relation_record.update!(properties.to_h)
      end
    end
  end

  puts '---------'
  count_after = ProductQuality.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} product qualities."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
