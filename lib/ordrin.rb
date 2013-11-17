require 'faraday'
require 'json'
require 'hashie'

module OrdrIn
  class Config
    def self.init(api_key, environment = :test)
      @api_key = api_key
      @environment = environment
    end

    def self.api_key
      @api_key
    end

    def self.api_key=(api_key)
      @api_key = api_key
    end

    def self.environment
      @environment
    end

    def self.environment=(environment)
      @environment = environment
    end
  end
end

require_relative "version"
require_relative "ordrin/request"
require_relative "ordrin/response"
require_relative "ordrin/errors"
require_relative 'ordrin/models/model'
require_relative "ordrin/models/restaurant"
require_relative "ordrin/models/restaurant_details"
require_relative "ordrin/models/delivery_check"
require_relative "ordrin/models/delivery_fee"
require_relative "ordrin/models/user"
require_relative "ordrin/restaurant_request"
require_relative "ordrin/user_request"
