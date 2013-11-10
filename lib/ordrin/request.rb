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
      request.send_request(:get, path)
    end

    def self.check_response(response)
      return if response.status.to_s =~ /2\d\d/
      if response.status == 401
        raise UnauthorizedError
      elsif response.status == 404
        raise NotFoundError, "Status: #{response.status}"
      else
        raise ServerError, "Status: #{response.status}"
      end
    rescue JSON::ParserError => e
      raise  JSON::ParserError, "Error parsing json: #{response.body}"
    end

    def body

    end

    def url
      ""
    end

    def send_request(method, path)
      response = connection.send(method, path) do |request|
        request["X-NAAMA-CLIENT-AUTHENTICATION"] = "id=#{OrdrIn::Config.api_key}, version=1"
      end
      OrdrIn::Request.check_response(response)
      response
    end
  end
end
