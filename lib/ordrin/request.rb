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

    def self.get(path)
      request = self.new
      request.send(:get, path)
    end

    def send(method, path)
      response = connection.send(method, path) do |request|
        request["X-NAAMA-CLIENT-AUTHENTICATION"] = "id=#{OrdrIn::Config.api_key}, version=1"
      end
    end
  end
end
