module V1
  module Public
    class ProductsController < V1::PublicController
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
        Product
      end

      def serializer_class
        V1::Public::ProductSerializer
      end

      def permitted_filters
        %i[
          name
          deprecated
          popular
          on_front_page
          main_family
          sub_family
        ]
      end

      def permanent_filters
        {
          public: true
        }
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
          product_uses.image
          product_videos
          product_videos.video
          qualities
          sub_family
          uses
          videos
        ]
      end
    end
  end
end
