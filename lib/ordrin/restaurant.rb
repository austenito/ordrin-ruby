module OrdrIn
  class Restaurant < Model
    attr_accessor :check, :delivery_fee, :restaurant_details

    def delivery_check(params)
      self.check ||= OrdrIn::Delivery.check(id, params)
    end

    def fee(params)
      self.delivery_fee ||= OrdrIn::Delivery.fee(id, params)
    end

    def details
      self.restaurant_details ||= OrdrIn::Restaurant.details(id)
    end

    def self.deliveries(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      response.body.collect { |attributes| OrdrIn::Restaurant.new(attributes) }
    end

    def self.details(restaurant_id)
      OrdrIn::RestaurantDetails.new(OrdrIn::RestaurantRequest.get("rd/#{restaurant_id}").body)
    end
  end
end
