after :companies do
  puts '---------'
  puts 'Seeding company members & people'
  puts '---------'

  CompanyMember.delete_all
  Person.delete_all

  count_before_member = CompanyMember.count
  count_before_person = Person.count

  file = File.read 'db/seeds/data/companies.yml'
  data = YAML.safe_load(file)

  data.each do |company_data|
    company_data = OpenStruct.new(company_data)
    company_record = Company.find_by(business_name: company_data.business_name)

    puts company_data.business_name

    debugger if company_record.nil?

    next if company_data.members.nil?

    company_data.members.each do |member|
      member = OpenStruct.new(member)

      puts "- #{member.first_name} #{member.last_name}"

      properties = OpenStruct.new(
         first_name: member.first_name,
         last_name: member.last_name,
         chinese_name: member.chinese_name,
         email: nil,
         phone: nil,
         male: member.male
      )

      person_record = Person.find_by(
        first_name: member.first_name,
        last_name: member.last_name
      )

      if person_record.nil?
        person_record = Person.create!(properties.to_h)
      else
        person_record.update!(properties.to_h)
      end

      properties = OpenStruct.new(
        company_id: company_record.id,
        person_id: person_record.id,
        title: member.title,
        email: member.email,
        phone: member.phone,
        public: true
      )

      member_record = CompanyMember.find_by(
        company_id: company_record.id,
        person_id: person_record.id
      )

      if member_record.nil?
        CompanyMember.create!(properties.to_h)
      else
        member_record.update!(properties.to_h)
      end
    end
  end

  puts '---------'
  count_after = CompanyMember.count
  difference = count_after - count_before_member
  puts "Before seeding, the database had #{count_before_member} company members."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  count_after = Person.count
  difference = count_after - count_before_person
  puts "Before seeding, the database had #{count_before_person} people."
  puts "After seeding, the database has #{count_after}."
  puts "That's #{difference} new ones."
  puts '---------'
  puts 'Success!'
  puts '---------'
  puts ' '
end
