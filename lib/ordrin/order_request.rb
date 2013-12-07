module OrdrIn
  class OrderRequest < Request
    def url
      if OrdrIn::Config.environment.to_sym == :production
        "https://o.ordr.in"
      else
        "https://o-test.ordr.in"
      end
    end
  end
end
