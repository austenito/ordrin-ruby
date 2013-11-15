module OrdrIn
  class UserRequest < Request
    def url
      if OrdrIn::Config.environment.to_sym == :production
        "https://u.ordr.in"
      else
        "https://u-test.ordr.in"
      end
    end
  end
end
