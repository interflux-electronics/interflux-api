after :products, :features do
  count_before = ProductFeature.count

  puts '---------'
  puts 'Seeding product features'
  puts '---------'

  file = File.read 'db/seeds/data/products.yml'
  data = YAML.safe_load(file)

  data.each_with_index do |_product, i|
    product = OpenStruct.new(_product)
    counter = i + 1
    spaces = ' ' * counter.to_s.length

    puts "#{counter} - #{product.name}"

    product_record = Product.find(product.slug)
    debugger if product_record.nil?

    if product.processes
      puts "#{spaces}   Processes:"
      product.processes.each do |process_slug|
        puts "#{spaces}   - #{process_slug}"

        feature_record = Feature.where(category: 'process').find(process_slug)
        debugger if feature_record.nil?

        properties = OpenStruct.new(
          product_id: product_record.id,
          feature_id: feature_record.id
        )

        relation_record = ProductFeature.where(product_id: product_record.id).where(feature_id: feature_record.id).first

        if relation_record.nil?
          ProductFeature.create!(properties.to_h)
        else
          relation_record.update!(properties.to_h)
        end
      end
    end

    if product.qualities
      puts "#{spaces}   Qualities:"
      product.qualities.each do |quality_slug|
        puts "#{spaces}   - #{quality_slug}"

        feature_record = Feature.find_by(slug: quality_slug, category: 'quality')
        next if feature_record.nil?

        properties = OpenStruct.new(
          product_id: product_record.id,
          feature_id: feature_record.id
        )

        relation_record = ProductFeature.where(product_id: product_record.id).where(feature_id: feature_record.id).first

        if relation_record.nil?
          ProductFeature.create!(properties.to_h)
        else
          relation_record.update!(properties.to_h)
        end
      end
    end

    # feature_record = Feature.find_by(slug: product.slug)
    # debugger if feature_record.nil?
    #
    #   product_record = Product.find_by(name: product_name)
    #   debugger if product_record.nil?
    #
    #   relation_record = ProductFeature.where(product_id: product_record.id).where(feature_id: feature_record.id).first
    #
    #   properties = OpenStruct.new(
    #     product_id: product_record.id,
    #     feature_id: feature_record.id
    #   )
    #
    #   if relation_record.nil?
    #     ProductFeature.create!(properties.to_h)
    #   else
    #     relation_record.update!(properties.to_h)
    #   end
  end

  puts '---------'
  count_after = ProductFeature.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} product feature."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
