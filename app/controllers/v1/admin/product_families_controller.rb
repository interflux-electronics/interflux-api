module V1
  module Admin
    class ProductFamiliesController < V1::AdminController
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
        allow_destroy
      end

      private

      def model_class
        ProductFamily
      end

      def serializer_class
        V1::Admin::ProductFamilySerializer
      end

      def permitted_includes
        %i[
          products
          products.image
          products.features
        ]
      end

      def permitted_filters
        %i[
          name_single
          name_plural
        ]
      end

      def creatable_attributes
        %i[
          id
          slug
          name_single
          name_plural
          gist
          the_full_monty
          rank
          public
        ]
      end

      def creatable_relationships
        %i[
          product_family
        ]
      end
    end
  end
end
