after :countries do
  puts '---------'
  puts 'Seeding companies'
  puts '---------'

  count_before = Company.count

  file = File.read 'db/seeds/data/companies.yml'
  data = YAML.safe_load(file)

  data.each_with_index do |company, i|
    company = OpenStruct.new(company)

    puts "#{i + 1} - #{company.business_name} - #{company.public}"

    emails = company.emails.join(',') if company.emails.present?
    country = Country.find_by(name_english: company.country)

    debugger if country.nil?

    properties = OpenStruct.new(
      business_name: company.business_name,
      legal_name: company.legal_name,
      address: company.address,
      phone: company.phone,
      fax: company.fax,
      latitude: company.latitude,
      longitude: company.longitude,
      emails: emails,
      website: company.website,
      country_id: country.id,
      public: !company.hidden
    )

    record = Company.find_by(business_name: company.business_name)

    if record.nil?
      Company.create!(properties.to_h)
    else
      record.update!(properties.to_h)
    end
  end

  puts '---------'
  count_after = Company.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} companies."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
