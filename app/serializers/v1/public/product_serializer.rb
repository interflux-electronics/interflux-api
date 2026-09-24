module V1
  module Public
    class ProductSerializer < ApplicationSerializer
      attributes :name,
                 :label,
                 :status,
                 :pitch,
                 :summary,
                 :properties,
                 :instructions,
                 :rank_among_family,
                 :complies_with_iso,
                 :complies_with_rohs,
                 :complies_with_iec,
                 :complies_with_ipcjstd004_a,
                 :complies_with_ipcjstd004_b,
                 :complies_with_ipcjstd005,
                 :test_results,
                 :avatar_path,
                 :avatar_variations,
                 :avatar_caption,
                 :avatar_alt,
                 :on_front_page,
                 :front_page_rank

      belongs_to :image
      belongs_to :main_family, serializer: :product_family
      belongs_to :sub_family, serializer: :product_family
      belongs_to :superior_product, serializer: :product

      has_many :uses, if: requested?('uses')
      has_many :product_uses, if: requested?('product_uses')

      has_many :qualities, if: requested?('qualities')
      has_many :product_qualities, if: requested?('product_qualities')

      has_many :images, if: requested?('images')
      has_many :product_images, if: requested?('product_images')

      has_many :videos, if: requested?('images')
      has_many :product_videos, if: requested?('product_images')

      has_many :documents, if: requested?('documents')
      has_many :product_documents, if: requested?('product_documents')

      cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.day
    end
  end
end
