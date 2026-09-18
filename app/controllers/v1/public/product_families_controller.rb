module V1
  module Public
    class ProductFamiliesController < V1::PublicController
      def index
        allow_index
      end

      def show
        allow_show
      end

      def create
        forbidden
      end

      def update
        forbidden
      end

      def destroy
        forbidden
      end

      private

      def model_class
        ProductFamily
      end

      def serializer_class
        V1::Public::ProductFamilySerializer
      end

      def permitted_includes
        %i[
          products
          products.image
          products.features
          product_family_images
          product_family_images.image
          products.sub_family
          product_uses
          uses
        ]
      end
    end
  end
end
