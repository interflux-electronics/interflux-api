class RemoveProductFamilyFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :product_family_id, :string
  end
end
