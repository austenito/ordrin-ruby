module OrdrIn
  class Response
    attr_accessor :http_request, :http_response, :errors

    def initialize(http_request, http_response)
      @http_request = http_request
      @http_response = http_response
      check_response
      add_errors
    end

    def body
      return @parsed_body if @parsed_body
      @parsed_body ||= JSON.parse(http_response.body)
    rescue JSON::ParserError => e
      raise JSON::ParserError, "Error parsing json: #{http_response.body}"
    end

    def errors?
      errors ? true : false
    end

    def add_errors
      if body["_err"] == 1
        self.errors = Hashie::Mash.new(msg: body["_msg"])
      end
      rescue
    end

    def check_response
      return if http_response.status.to_s =~ /2\d\d/
      if http_response.status == 401
        raise UnauthorizedError
      elsif http_response.status == 404
        raise NotFoundError, "Status: #{http_response.status}"
      elsif http_response.status.to_s =~ /5\d\d/
        raise ServerError, "Status: #{http_response.status}"
      end
    end
  end
end
