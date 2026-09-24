require 'test_helper'

module V1
  module Public
    class ProductIntegrationTest < ActionDispatch::IntegrationTest
      def setup
        @header = public_header
      end

      # curl 'http://localhost:3000/v1/public/products' -H "Content-Type: application/vnd.api+json"
      test 'can fetch all' do
        get '/v1/public/products', headers: @header

        # Should be allowed
        assert_response 200

        json = JSON.parse(@response.body)

        # Should return 6 out of 7 products (should filter out public=false)
        assert_equal 6, json['data'].length
      end

      test 'can fetch one by slug' do
        # curl 'http://localhost:3000/v1/public/products?slug=LMPA-Q6' -H "Content-Type: application/vnd.api+json"
        get '/v1/public/products/LMPA-Q6', headers: @header

        # Should be allowed
        assert_response 200

        json = JSON.parse(@response.body)

        # Returns ID for given slug (important)
        assert_not_nil json['data']['id']

        # Returns attributes
        assert_not_nil json['data']['attributes']['name']
        assert_not_nil json['data']['attributes']['status']

        # Returns relationships
        # assert_not_nil json['data']['relationships']['product-family']

        # Should not include other records included
        # assert_nil json['includes']
      end

      test 'can include product family' do
        skip('TODO: improve test')

        get '/v1/public/products/LMPA-Q6?include=main_family', headers: @header

        # Should be allowed
        assert_response 200

        json = JSON.parse(@response.body)

        # Includes extra records
        assert_not_nil json['included']
        assert_equal 1, json['included'].length
        assert_equal 'product-family', json['included'][0]['type']
        assert_equal 'solder paste', json['included'][0]['attributes']['name-single']
      end

      test 'can include family and images' do
        skip('TODO: includes become optional in the payload')

        # curl "http://localhost:3000/v1/public/products?slug=LMPA-Q6&include=product-family,product-images,product-images.image" -H "Content-Type: application/vnd.api+json"
        get '/v1/public/products?slug=IF-2005M&include=product-family,product-images,product-images.image', headers: @header

        # Should be allowed
        assert_response 200

        json = JSON.parse(@response.body)

        # Includes 2 extra records
        assert_not_nil json['included']

        assert_equal 5, json['included'].length
        assert_equal 'product-family', json['included'][0]['type']
        assert_equal 'product-image', json['included'][1]['type']
        assert_equal 'product-image', json['included'][2]['type']
        assert_equal 'image', json['included'][3]['type']
        assert_equal 'image', json['included'][4]['type']
      end

      test 'throws 403 if bogus filter' do
        # curl "http://localhost:3000/v1/public/products?filter%5Bbogus%5D=true" -H "Content-Type: application/vnd.api+json"
        get '/v1/public/products?filter[bogus]=true', headers: @header
        assert_response 403
      end

      test 'does not allow create' do
        post '/v1/public/products', headers: @header
        assert_response 403
      end

      test 'does not allow update' do
        put '/v1/public/products/123', headers: @header
        assert_response 403
      end

      test 'does not allow delete' do
        delete '/v1/public/products/123', headers: @header
        assert_response 403
      end
    end
  end
end
