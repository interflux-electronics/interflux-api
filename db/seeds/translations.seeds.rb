def seed(list, language)
  list.each do |item|
    struct = OpenStruct.new(item)

    english = nil
    # needs_review = false
    # review_reason = nil

    if language != 'en'
      english_record = Translation.find_by(language: 'en', key: struct.key)
      debugger if english_record.nil?
      english = english_record.native
      debugger if english.nil?
      # needs_review = true
      # review_code = 'robot-translated'
    end

    properties = OpenStruct.new(
      key: struct.key,
      language: language,
      native: struct.native,
      english: english
      # needs_review: needs_review,
      # review_code: review_code
    )

    record = Translation.find_by(language: language, key: struct.key)

    if record.nil?
      puts "#{language} | #{struct.key} | CREATE"
      new_record = Translation.create!(properties.to_h)
      TranslationEvent.create!(code: 'created', updated_by: 'Jan', translation: new_record)
    elsif record.native == struct.native
      puts "#{language} | #{struct.key} | ok"
    else
      record.update!(properties.to_h)
      TranslationEvent.create!(code: 'source-update', updated_by: 'Jan', translation: record)
      puts "#{language} | #{struct.key} | UPDATE"
    end
  end
  puts '---------'
end

en_file = File.read 'db/seeds/data/translations-en.yml'
es_file = File.read 'db/seeds/data/translations-es.yml'

en_data = YAML.safe_load(en_file)
es_data = YAML.safe_load(es_file)

puts '---------'
puts 'Seeding translations'
puts '---------'

count_before = Translation.count

seed(en_data, 'en')
seed(es_data, 'es')

puts '---------'
count_after = Translation.count
difference = count_after - count_before
puts "Before seeding, the database had #{count_before} translations."
puts "After seeding, the database has #{count_after}."
puts "That's #{difference} new ones."
puts '---------'
puts 'Success!'
puts '---------'
puts ' '
