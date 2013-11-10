module OrdrIn
  class DeliveryList
    def self.restaurants(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      response.body.collect { |attributes| OrdrIn::Restaurant.new(attributes) }
    end
  end
end
