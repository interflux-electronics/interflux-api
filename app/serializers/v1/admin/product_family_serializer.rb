module V1
  module Admin
    class ProductFamilySerializer < ApplicationSerializer
      attributes :slug,
                 :name_single,
                 :name_plural,
                 :gist,
                 :the_full_monty,
                 :rank

      belongs_to :product_family

      has_many :products, if: requested?('products')
    end
  end
end
