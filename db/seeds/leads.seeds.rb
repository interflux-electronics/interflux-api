require 'yaml'
require 'ap'

after :countries do
  count_before = Lead.count

  puts '---------'
  puts 'Seeding leads'
  puts '---------'

  file = File.read 'db/seeds/data/leads.yml'
  data = YAML.safe_load(file)

  data.each_with_index do |_lead, i|
    lead = OpenStruct.new(_lead)

    puts "#{i + 1} - #{lead.email}"

    record = Lead.find_by(email: lead.email)

    properties = OpenStruct.new(
      name: lead.name,
      company: lead.company,
      email: lead.email,
      mobile: lead.mobile,
      message: lead.message,
      purpose: lead.purpose,
      source: lead.source,
      country_id: Country.where(two_letter_code: lead.country_id).first.id,
      ip_country_id: Country.where(two_letter_code: lead.ip_country_id).first.id,
      ip_region: lead.ip_region,
      ip_city: lead.ip_city,
      ip: lead.ip
    )

    if record.nil?
      Lead.create!(properties.to_h)
    else
      record.update!(properties.to_h)
    end
  end

  puts '---------'
  count_after = Lead.count
  difference = count_after - count_before
  puts "Before seeding, the database had #{count_before} leads."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
