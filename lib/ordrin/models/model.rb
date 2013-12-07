module OrdrIn
  class Model
    attr_accessor :model, :errors

    def initialize(attributes, errors = nil)
      @model = Hashie::Mash.new(attributes)
      @errors = errors
    end

    def method_missing(method, *args)
      return model.send(method, *args) if model.respond_to?(method)
      super
    end

    def errors?
      errors ? true : false
    end
  end

  class DeliveryCheck < Model; end;
  class DeliveryFee < Model; end;
  class RestaurantDetails < Model; end;
  class UserDetails < Model; end;
  class CreditCard < Model; end;
  class Order < Model; end;

  class Address < Model
    # Overrides Enumerable#zip because the ordr.in API returns zip codes as
    # "zip"
    def zip
      model[:zip]
    end
  end
end
