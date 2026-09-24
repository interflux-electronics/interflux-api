module V1
  module Admin
    class QualitiesController < ApplicationController
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
        Quality
      end

      def serializer_class
        V1::Admin::QualitySerializer
      end

      def permitted_filters
        %i[
          text
        ]
      end

      def permitted_includes
        %i[
          image
          products
          products.image
          product_qualities
        ]
      end

      def creatable_attributes
        %i[
          slug
          text
          icon
          gist
        ]
      end

      def creatable_relationships
        %i[
          image
          product_quality
        ]
      end
    end
  end
end
