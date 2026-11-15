puts '---------'
puts 'Linking product avatars'
puts '---------'

Product.all.each do |product|
  next if product.image.present?
  next if product.images.empty?
  image = product.images.shuffle.first
  debugger if image.nil?
  puts "#{product.name} > #{image.path}"
  product.avatar = image
  product.save!
end

puts '---------'
puts 'Success!'
puts '---------'
puts ' '
