module OrdrIn
  class User < Model
    attr_accessor :details

    # @return [OrdrIn::UserDetails]
    def details
      return @details if @details
      url = "/u/#{encode_email}"
      @details = OrdrIn::UserDetails.new(UserRequest.get(url, user_params).body)
    end

    # @param params [Hash] testing
    # @option params [String] :first_name
    # @option params [String] :last_name
    # @return [OrdrIn::Account]
    def create_account(params)
      OrdrIn::Account.new(UserRequest.post("/u/#{encode_email}", user_params(params)).body)
    end

    # @param params [Hash] testing
    # @option params [String]  :nick
    # @option params [String]  :addr
    # @option params [String]  :addr2 optional
    # @option params [String]  :city
    # @option params [String]  :state 2 letter state. Ex. NY
    # @option params [Integer] :zip
    # @option params [String]  :phone
    # @return [Boolean]
    def create_address(params)
      response = UserRequest.put("/u/#{encode_email}/addrs/#{params[:nick]}", user_params(params))
      OrdrIn::Address.new(response.body).msg == "Address set" ? true : false
    end

    private

    def user_params(params = {})
      { email: email, password: password }.merge(params)
    end

    def encode_email
      CGI.escape(model.email)
    end
  end
end
