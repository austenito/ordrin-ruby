module OrdrIn
  class Model
    attr_accessor :model

    def initialize(attributes)
      @model = Hashie::Mash.new(attributes)
    end

    def method_missing(method, *args)
      return model.send(method, *args) if model.respond_to?(method)
      super
    end
  end

  class DeliveryCheck < Model; end;
  class DeliveryFee < Model; end;
  class RestaurantDetails < Model; end;
  class UserDetails < Model; end;

  class Address < Model
    # Overrides Enumerable#zip because the ordr.in API returns zip codes as
    # "zip"
    def zip
      model[:zip]
    end
  end
end
