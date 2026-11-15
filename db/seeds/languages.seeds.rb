require 'json'
require 'ap'

count_before = Language.count

puts '---------'
puts 'Seeding languages'
puts '---------'

file = File.read 'db/seeds/data/countries.json'
data = JSON.parse(file)

data.each_with_index do |hash, i|
  country = OpenStruct.new(hash)
  country.languages.each do |lang|
    language = OpenStruct.new(lang)
    puts "#{i} - #{language.name} (#{country.name})"
    record = Language.find_by(two_letter_code: language.iso639_1)

    public = ['en', 'fr', 'de', 'ja', 'es'].include?(language.iso639_1)

    properties = OpenStruct.new(
      name_english: language.name,
      name_native: language.native_name,
      two_letter_code: language.iso639_1,
      three_letter_code: language.iso639_2,
      public: public
    )

    debugger if language.iso639_1.nil?

    if record.nil?
      Language.create!(properties.to_h)
    else
      record.update!(properties.to_h)
    end
  end
end

puts '---------'
count_after = Language.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} languages."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
