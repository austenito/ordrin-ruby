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
require_relative 'ordrin/model'
require_relative "ordrin/request"
require_relative "ordrin/response"
require_relative "ordrin/restaurant_request"
require_relative "ordrin/restaurant"
require_relative "ordrin/restaurant_details"
require_relative "ordrin/delivery_check"
require_relative "ordrin/delivery_fee"
require_relative "ordrin/errors"
