module V1
  module Admin
    class ProductsController < V1::AdminController
      def index
        allow_index
      end

      def show
        allow_show
      end

      def create
        allow_create
      end

      def update
        allow_update
      end

      def destroy
        forbidden
      end

      private

      def model_class
        Product
      end

      def serializer_class
        V1::Admin::ProductSerializer
      end

      def permitted_filters
        %i[
          name
        ]
      end

      def permitted_includes
        %i[
          documents
          documents.language
          image
          images
          main_family
          product_documents
          product_images
          product_images.image
          product_qualities
          product_uses
          product_videos
          product_videos.video
          qualities
          sub_family
          uses
          videos
        ]
      end

      def creatable_attributes
        %i[
          slug
          name
          label
          status
          pitch
          summary
          properties
          instructions
          rank_among_family
          complies_with_iso
          complies_with_rohs
          complies_with_iec
          complies_with_ipcjstd004_a
          complies_with_ipcjstd004_b
          complies_with_ipcjstd005
          test_results
          on_front_page
          front_page_rank
        ]
      end

      def creatable_relationships
        %i[
          main_family
          sub_family
          image
          superior_product
        ]
      end
    end
  end
end
