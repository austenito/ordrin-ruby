module OrdrIn
  class DeliveryList
    def self.restaurants(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      JSON.parse(response.body).collect do |attributes|
        OrdrIn::Restaurant.new(attributes)
      end
    end
  end
end
