module OrdrIn
  class Delivery

    def self.check(restaurant_id, params)
      url = URI.escape("dc/#{restaurant_id}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryCheck.new(response.body)
    end

    def self.fee(restaurant_id, params)
      url = URI.escape("fee/#{restaurant_id}/#{params[:subtotal]}/#{params[:tip]}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryFee.new(response.body)
    end
  end
end
