puts '---------'
puts 'Seeding documents'
puts '---------'

cdn_files = CdnFile.all

cdn_files.each_with_index do |file, i|
  # Skip all CDN paths that aren't documents
  next unless file.path.start_with?('documents/')

  category = file.path.split('/').second
  category = 'TD' if category == 'series'
  category = 'TD' if category == 'products'
  category = DocumentCategory.find(category)

  name = file.path.split('/').last.split('.').first[0...-3].gsub("-", " ")
  shared_path = file.path[0...-7]

  debugger if category.nil?

  variations = cdn_files.filter { |x| x.path.starts_with? shared_path } .map { |x| x.path.split('-').last } .join(',')

  props = OpenStruct.new(
    path: shared_path,
    name: name,
    document_category_id: category.slug,
    variations: variations
  )

  document = Document.find_by(path: shared_path)

  puts "#{i} | #{category.slug} | #{shared_path}"

  if document.nil?
    document = Document.create!(props.to_h)
  else
    document.update!(props.to_h)
  end

  debugger if document.nil?

  file.document_id = document.id
  file.save!
end

puts '---------'
puts 'Success!'
puts '---------'
puts ' '
