module OrdrIn
  class RestaurantRequest < Request
    def url
      if OrdrIn::Config.environment.to_sym == :production
        "https://r.ordr.in"
      else
        "https://r-test.ordr.in"
      end
    end
  end
end
