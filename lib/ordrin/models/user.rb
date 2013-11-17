module OrdrIn
  class User < Model
    attr_accessor :email, :password, :details

    @return [OrdrIn::UserDetails]
    def details
      return @details if @details
      url = "/u/#{encode_email}"
      @details = Hashie::Mash.new(UserRequest.get(url, user_params).body)
    end

    # @param params [Hash] testing
    # @option params [String] :first_name
    # @option params [String] :last_name
    # @return [OrdrIn::Account]
    def create_account(params)
      Hashie::Mash.new(UserRequest.post("/u/#{encode_email}", user_params.merge(params)).body)
    end

    # @param params [Hash] testing
    # @option params [String]  :nick
    # @option params [String]  :addr
    # @option params [String]  :addr2 optional
    # @option params [String]  :city
    # @option params [String]  :state 2 letter state. Ex. NY
    # @option params [Integer] :zip
    # @option params [String]  :phone
    # @return [OrdrIn::Address]
    def create_address(params)

    end

    private

    def user_params
      { email: model.email, password: model.password }
    end

    def encode_email
      CGI.escape(model.email)
    end
  end
end
