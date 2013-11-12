module OrdrIn
  class Restaurant < Model
    attr_accessor :check

    def delivery_check(params)
      self.check ||= OrdrIn::Delivery.check(id, params)
    end

    def fee(params)
      self.check ||= OrdrIn::Delivery.fee(id, params)
    end

    def self.deliveries(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      response.body.collect { |attributes| OrdrIn::Restaurant.new(attributes) }
    end
  end
end
