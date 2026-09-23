module JsonApiSerializer
  extend ActiveSupport::Concern

  # These method live on all serializers which extend JsonApiSerializer.
  class_methods do
    # This method returns a function (proc) which runs each time a record is being serialized.
    # This method accepts one param: the name of a relationship.
    # Its purpose is to include the data of a relationship if the request ask for it.
    #
    # The intention is to adhere to the JSON API spec.
    # https://jsonapi.org/format/#fetching-includes
    #
    # The controller is responsible for white listing includes.
    # Define `permitted_includes` on controllers to filter out unwanted includes.
    #
    def requested?(relationship)
      proc { |_record, params|
        # Only continue if requests includes the param `include`.
        next false unless params && params['include'].present?

        # The relationships which the requests asks to include in the payload.
        # For example: `?include=products,product.uses`
        # ['products', 'product.uses']
        requested_includes = params['include'].split(',')

        # The relationship passed into the proc gets broken up in parts.
        # 'products' → ['product']
        # 'products.uses' → ['products', 'uses']
        needed = relationship.to_s.underscore.split('.')

        # The requested includes will only be included if they match the relationship param.
        requested_includes.any? do |requested_include|
          # The requested include uses dot notation.
          # Here we break them up in segments.
          segments = requested_include.strip.underscore.split('.')

          # Exit early
          next false if needed.empty? || segments.size < needed.size

          # Allow include if `needed` appears as consecutive segments in this include path.
          # needed ["uses"]             vs segments ["products", "uses"]          → true
          # needed ["products"]         vs segments ["products", "uses"]          → true
          # needed ["products", "uses"] vs segments ["products", "uses", "image"] → true
          (0..(segments.size - needed.size)).any? do |start|
            segments[start, needed.size] == needed
          end
        end
      }
    end
  end
end
