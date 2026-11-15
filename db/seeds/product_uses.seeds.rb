after :products, :uses do
  count_before = ProductUse.count

  puts '---------'
  puts 'Seeding product uses'
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

    next if product.uses.nil?

    puts "#{spaces}   Qualities:"

    product.uses.each do |slug|
      puts "#{spaces}   - #{slug}"

      use = Use.find(slug)

      next if use.nil?

      properties = OpenStruct.new(
        product_id: product_record.id,
        use_id: use.id
      )

      relation_record = ProductUse.where(product_id: product_record.id).where(use_id: use.id).first

      if relation_record.nil?
        ProductUse.create!(properties.to_h)
      else
        relation_record.update!(properties.to_h)
      end
    end
  end

  puts '---------'
  count_after = ProductUse.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} product uses."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
