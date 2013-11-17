module OrdrIn
  class Restaurant < Model

    def delivery_check(params)
      url = URI.escape("dc/#{id}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryCheck.new(response.body)
    end

    def delivery_fee(params)
      url = URI.escape("fee/#{id}/#{params[:subtotal]}/#{params[:tip]}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryFee.new(response.body)
    end

    def details
      OrdrIn::RestaurantDetails.new(OrdrIn::RestaurantRequest.get("rd/#{id}").body)
    end

    def self.deliveries(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      response.body.collect { |attributes| OrdrIn::Restaurant.new(attributes) }
    end
  end
end
