module OrdrIn
  class Response
    attr_accessor :http_request, :http_response

    def initialize(http_request, http_response)
      @http_request = http_request
      @http_response = http_response
      check_response
    end

    def body
      @parsed_body ||= JSON.parse(http_response.body)
    rescue JSON::ParserError => e
      raise JSON::ParserError, "Error parsing json: #{http_response.body}"
    end

    def check_response
      return if http_response.status.to_s =~ /2\d\d/
      if http_response.status == 401
        raise UnauthorizedError
      elsif http_response.status == 404
        raise NotFoundError, "Status: #{http_response.status}"
      else
        raise ServerError, "Status: #{http_response.status}"
      end
    end
  end
end
