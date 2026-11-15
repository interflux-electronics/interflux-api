puts '---------'
puts 'Seeding product documents'
puts '---------'

Document.all.each_with_index do |document, i|
  next unless document.path.start_with?('documents/products/')

  slug = document.path.split('/').third
  product = Product.find_by(slug: slug)
  debugger if product.nil?

  props = OpenStruct.new(
    product_id: product.id,
    document_id: document.id,
  )

  record = ProductDocument.find_by(document_id: document.id, product_id: product.id)

  if record.nil?
    ProductDocument.create!(props.to_h)
  else
    record.update!(props.to_h)
  end

  document.name = document.path.split("/").last.gsub("-", " ").chomp('.pdf').chomp(' FR').chomp(' EN').chomp(' DE')
  document.name = document.name.sub(product.name.gsub("-", " "), product.name)
  document.save!

  puts "#{i} | #{product.slug} | #{document.path}"
end

puts '---------'
puts 'Success!'
puts '---------'
puts ' '
