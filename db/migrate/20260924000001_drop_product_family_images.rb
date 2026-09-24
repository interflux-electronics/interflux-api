class DropProductFamilyImages < ActiveRecord::Migration[6.1]
  def change
    drop_table :product_family_images
  end
end
