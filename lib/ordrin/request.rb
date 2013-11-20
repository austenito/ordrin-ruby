module OrdrIn
  class Request
    attr_accessor :connection

    def initialize
      raise "API Key not set" unless OrdrIn::Config.api_key

      @connection = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def url
      ""
    end

    def send_request(method, path, params = {})
      response = connection.send(method, path) do |request|
        request["X-NAAMA-CLIENT-AUTHENTICATION"] = "id=#{OrdrIn::Config.api_key}, version=1"

        email = params.delete(:email)
        password = params.delete(:password)
        if email && password
          hash_code = generate_hash_code(email, password, path)
          request["X-NAAMA-AUTHENTICATION"] = "username=\"#{email}\", response=\"#{hash_code}\", version=\"1\""
        end
        request.body = params.to_json
      end
      OrdrIn::Response.new(self, response)
    end

    def self.get(path, params = {})
      new.send_request(:get, path, params)
    end

    def self.post(path, params = {})
      new.send_request(:post, path, params)
    end

    def self.put(path, params = {})
      new.send_request(:put, path, params)
    end

    def self.delete(path, params = {})
      new.send_request(:delete, path, params)
    end

    private

    def generate_hash_code(email, password, path)
      hashed_password = Digest::SHA256.new.hexdigest(password)
      Digest::SHA256.new.hexdigest("#{hashed_password}#{email}#{path}")
    end
  end
end
