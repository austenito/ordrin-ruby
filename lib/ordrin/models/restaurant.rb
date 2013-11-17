module OrdrIn
  class Restaurant < Model

    # @param params [Hash]
    # @option params [String]  :date_time Either "ASAP" or the format is 
    #   [2 # digit month]-[2 digit day]+[2 digit hours (24 hour clock):[2 digit minutes]
    # @option params [String]  :address
    # @option params [String]  :city
    # @option params [Integer] :zip_code
    # @return [OrdrIn::DeliveryCheck]
    def delivery_check(params)
      url = URI.escape("dc/#{id}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryCheck.new(response.body)
    end

    # @param params [Hash]
    # @option params [Float]   :subtotal
    # @option params [Float]   :tip
    # @option params [String]  :date_time Either "ASAP" or the format is 
    #   [2 # digit month]-[2 digit day]+[2 digit hours (24 hour clock):[2 digit minutes]
    # @option params [String]  :addr
    # @option params [String]  :city
    # @option params [Integer] :zip_code
    # @return [OrdrIn::DeliveryCheck]
    def delivery_fee(params)
      url = URI.escape("fee/#{id}/#{params[:subtotal]}/#{params[:tip]}/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      OrdrIn::DeliveryFee.new(response.body)
    end

    def details
      OrdrIn::RestaurantDetails.new(OrdrIn::RestaurantRequest.get("rd/#{id}").body)
    end

    # @param params [Hash]
    # @option params [String]  :date_time Either "ASAP" or the format is 
    #   [2 # digit month]-[2 digit day]+[2 digit hours (24 hour clock):[2 digit minutes]
    # @option params [String]  :addr
    # @option params [String]  :city
    # @option params [Integer] :zip_code
    # @return [OrdrIn::Restaurant]
    def self.deliveries(params)
      url = URI.escape("dl/#{params[:date_time]}/#{params[:zip_code]}/#{params[:city]}/#{params[:address]}")
      response = OrdrIn::RestaurantRequest.get(url)
      response.body.collect { |attributes| OrdrIn::Restaurant.new(attributes) }
    end
  end
end
