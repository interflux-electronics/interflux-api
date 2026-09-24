require 'csv'
require 'byebug'
require 'ap'

after :product_families,
      :products,
      :features,
      :containers do

  puts '---------'
  puts 'Seeding product variants'
  puts '---------'

  count_before = ProductVariant.count

  file1 = File.read 'db/seeds/data/product_variants.csv'
  file2 = File.read 'db/seeds/data/products.yml'

  variants = CSV.parse(file1)
  products = YAML.safe_load(file2)

  variants.each_with_index do |variant, i|
    code = variant[0]
    name = variant[1]

    byebug if code.nil?
    byebug if name.nil?

    # Remove double spaces
    name = name.gsub(/  /, ' ')

    # Normalise the names for consistency
    replacements = [
      [/^Interflux /, ''],
      ['µ- dIFe', 'µ-dIFe'],
      ['Bright1', 'Bright 1'],
      ['Delphine ', 'DP '],
      ['DP5600', 'DP 5600'],
      ['IF 710/V4', 'IF 710 V4'],
      ["IF 9007'", 'IF 9007'],
      ['IF14-', 'IF 14-'],
      ['IF8300', 'IF 8300'],
      ['IF910', 'IF 910'],
      ['í-Flex', 'i-Flex'],
      ['Anti-Oxidant Pellets', 'Anti-oxidant pellets'],
      ['NH1', 'NH 1'],
      %w[Pacific PacIFic],
      ['Plain Solderwire', 'Plain solder wire'],
      ['Solder pellets/Grenaille', 'Solder pellets'],
      ['Solder Stones', 'Solder stones'],
      ['Solderbar', 'Solder bar'],
      ['Solder bar(', 'Solder bar '],
      ['Soldersticks', 'Solder sticks'],
      ['Solderwire', 'Solder wire'],
      ['TerrIFic RP 65', 'TerrIFic RP65'],
      ['(1,6%)', '1,6%'],
      ['(2,5%)', '2,5%'],
      ['(2,2%)', '2,2%'],
      ['(3,5%)', '3,5%'],
      ['(3%)', '3%'],
      ['Optimum-spuit 10cc', '(10cc Optimum syringe)'],
      ['10cc Optimum syr clear wiper', '(10cc Optimum syringe with clear wiper)'],
      ['-100g spool', ' (100g spool)'],
      %w[HPDE HDPE]
    ]
    replacements.each do |arr|
      name = name.sub(arr[0], arr[1])
    end

    matches = products.select do |product|
      regex1 = product['regex1']
      regex2 = product['regex2']

      if regex1.present? && regex2.present?
        match1 = name.match?(/#{product['regex1']}/i)
        match2 = name.match?(/#{product['regex2']}/i)
        match1 && match2
      elsif regex1.present?
        name.match?(/#{product['regex1']}/i)
      else
        name.match?(/#{product['name']} /i)
      end
    end

    byebug if matches.count < 1
    byebug if matches.count > 1

    product = Product.find_by(slug: matches.first['slug'])

    container_name = name[/\((.*?)\)$/, 1]

    if container_name
      replacements = [
        [/syr$/, 'syringe'],
        ['syr ', 'syringe '],
        ['all in one', 'all-in-one'],
        ['All in One', 'all-in-one'],
        ['spool-6kg', 'spool - 6kg'],
        ['6kg box-100g spool', '100g spool - 6kg box'],
        %w[jars jar],
        [' cc', 'cc'],
        ['Poly-syringe', 'poly-syringe'],
        [/cart$/, 'cartridge'],
        ['syr+red plunger', 'syringe with red plunger'],
        ['1L HDPE Bottle', '1L HDPE bottle'],
        ['1L Bottle', '1L HDPE bottle'],
        ['1L bottle', '1L HDPE bottle'],
        ['100ml HDPE bottle', '100mL HDPE bottle'],
        %w[500ml 500mL]
      ]
      replacements.each do |arr|
        container_name = container_name.sub(arr[0], arr[1])
      end

      container = Container.find_by(name: container_name)
    end

    byebug if product.nil?

    properties = OpenStruct.new(
      code: code,
      name: name,
      product_id: product.id
    )

    puts "#{i} | #{product.main_family.name_single} | #{product.name} | #{properties.name}"

    if container.nil?
      puts "////// No container for: #{code} - #{name} //////"
    else
      properties.container_id = container.id
    end

    record = ProductVariant.find_by(code: code)

    if record.nil?
      ProductVariant.create!(properties.to_h)
    else
      record.update!(properties.to_h)
    end
  end

  puts '---------'
  count_after = ProductVariant.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} product variants."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
