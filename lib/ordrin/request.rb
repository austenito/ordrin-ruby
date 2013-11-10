module OrdrIn
  class Request
    attr_accessor :connection

    def initialize
      raise "API Key not set" unless OrdrIn::Config.api_key

      @connection = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        #faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def url
      ""
    end

    def send_request(method, path)
      response = connection.send(method, path) do |request|
        request["X-NAAMA-CLIENT-AUTHENTICATION"] = "id=#{OrdrIn::Config.api_key}, version=1"
      end
      OrdrIn::Response.new(self, response)
    end

    def self.get(path)
      request = self.new
      request.send_request(:get, path)
    end
  end
end
