require 'json'
require 'ap'

count_before = Currency.count

puts '---------'
puts 'Seeding currencies'
puts '---------'

file = File.read 'db/seeds/data/countries.json'
data = JSON.parse(file)

data.each_with_index do |hash, i|
  country = OpenStruct.new(hash)
  country.currencies.each do |curr|
    currency = OpenStruct.new(curr)
    puts "#{i} - Seeding #{currency.code} (#{country.name})"
    if currency.code.nil? || currency.code == '(none)'
      puts '//////'
      puts 'WARNING: No currency code'
      puts currency.to_json
      puts '//////'
    else
      record = Currency.find_by(code: currency.code)
      properties = OpenStruct.new(
        code: currency.code,
        name: currency.name,
        symbol: currency.symbol
      )
      if record.nil?
        Currency.create!(properties.to_h)
      else
        record.update!(properties.to_h)
      end
    end
  end
end

puts '---------'
count_after = Currency.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} country currencies."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
