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
end
