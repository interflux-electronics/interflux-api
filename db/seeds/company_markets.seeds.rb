after :countries, :companies do
  puts '---------'
  puts 'Seeding company markets'
  puts '---------'

  CompanyMarket.delete_all

  count_before = CompanyMarket.count

  file = File.read 'db/seeds/data/companies.yml'
  data = YAML.safe_load(file)

  data.each do |company_data|
    company_data = OpenStruct.new(company_data)

    next if company_data.markets.nil?

    company_record = Company.find_by(business_name: company_data.business_name)

    puts company_data.business_name

    debugger if company_record.nil?

    company_data.markets = Country.all.map{|c| c[:name_english]} if company_data.markets.first == 'World'

    company_data.markets.each do |market|
      puts "- #{market}"

      country_record = Country.find_by(name_english: market)

      debugger if country_record.nil?

      properties = OpenStruct.new(
        company_id: company_record.id,
        country_id: country_record.id
      )

      record = CompanyMarket.find_by(
        company_id: company_record.id,
        country_id: country_record.id
      )

      if record.nil?
        CompanyMarket.create!(properties.to_h)
      else
        record.update!(properties.to_h)
      end
    end
  end

  puts '---------'
  count_after = CompanyMarket.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} company markets."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
