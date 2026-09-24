module V1
  module Public
    class ProductFamilySerializer < ApplicationSerializer
      attributes :slug,
                 :name_single,
                 :name_plural,
                 :gist,
                 :the_full_monty,
                 :rank

      belongs_to :product_family

      has_many :products, if: requested?('products')
      has_many :product_uses, if: requested?('product_uses')
      has_many :uses, if: requested?('uses')

      cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.day
    end
  end
end
