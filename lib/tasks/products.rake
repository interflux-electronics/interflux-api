namespace :products do
  task create_new_families: :environment do
    puts '---------'
    puts 'Creating new families'
    puts '---------'

    Product.all.each do |product|
      family = product.main_family

      if family.sub_family?
        product.update!(
          main_family: family.parent,
          sub_family: family
        )
      else
        product.update!(
          main_family: family
        )
      end
    end

    puts '---------'
    puts 'Done'
    puts '---------'
  end
end
