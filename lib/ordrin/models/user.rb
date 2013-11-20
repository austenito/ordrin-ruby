module OrdrIn
  class User < Model
    attr_accessor :details

    def details
      return @details if @details
      url = "/u/#{encode_email}"
      response = UserRequest.get(url, user_params)
      @details = OrdrIn::UserDetails.new(response.body)
    end

    # @param params [Hash] testing
    # @option params [String] :email
    # @option params [String] :password
    # @option params [String] :first_name
    # @option params [String] :last_name
    # @return [OrdrIn::User]
    def self.create_account(params)
      response = UserRequest.post("/u/#{encode_email(params[:email])}", params)
      OrdrIn::User.new(response.body.merge(params), response.errors)
    end

    # @param params [Hash]
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
      OrdrIn::Address.new(response.body.merge(params), response.errors)
    end

    def all_addresses
      return @addresses if @addresses
      response = UserRequest.get("/u/#{encode_email}/addrs", user_params)
      @addresses = response.body.values.collect do |address_attributes|
        OrdrIn::Address.new(address_attributes)
      end
    end

    def address(nickname)
      return @address if @address
      response = UserRequest.get("/u/#{encode_email}/addrs/#{nickname}", user_params)
      @address = OrdrIn::Address.new(response.body)
    end

    def remove_address(nickname)
      response = UserRequest.delete("/u/#{encode_email}/addrs/#{nickname}", user_params)
      OrdrIn::Address.new(response.body).msg == "Address removed: #{nickname}" ? true : false
    end

    # @param params [Hash]
    # @option params [String]  :nick
    # @option params [String]  :name
    # @option params [String]  :number Ex: 4242424242424242
    # @option params [Integer] :cvc
    # @option params [String]  :expiry_month Ex: 02
    # @option params [String]  :expiry_year Ex: 2042
    # @option params [String]  :type Ex: American Express
    # @option params [String]  :bill_addr
    # @option params [String]  :bill_addr2 optional
    # @option params [String]  :bill_city
    # @option params [String]  :bill_state Ex: NY
    # @option params [Integer] :bill_zip
    # @option params [String]  :bill_phone
    def create_credit_card(params)
      response = UserRequest.put("/u/#{encode_email}/ccs/#{params[:nick]}", user_params)
      OrdrIn::CreditCard.new(response.body)
    end

    private

    def user_params(params = {})
      { email: email, password: password }.merge(params)
    end

    def encode_email
      OrdrIn::User.encode_email(email)
    end

    def self.encode_email(email)
      CGI.escape(email)
    end
  end
end
