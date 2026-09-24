module V1
  module Public
    class ProductUsesController < V1::PublicController
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
        ProductUse
      end

      def serializer_class
        V1::Public::ProductUseSerializer
      end

      def permitted_filters
        %i[
          use
          product
        ]
      end

      def permitted_includes
        %i[
          image
          use
          product
          product.uses
        ]
      end
    end
  end
end
