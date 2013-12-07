module OrdrIn
  class User < Model
    attr_accessor :details

    def details
      return @details if @details
      url = "/u/#{encode_email}"
      response = UserRequest.get(url, user_params)
      @details = OrdrIn::UserDetails.new(response.body, response.errors)
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
      response = UserRequest.get("/u/#{encode_email}/addrs", user_params)
      response.body.values.collect do |address_attributes|
        OrdrIn::Address.new(address_attributes, response.errors)
      end
    end

    def address(nickname)
      response = UserRequest.get("/u/#{encode_email}/addrs/#{nickname}", user_params)
      OrdrIn::Address.new(response.body, response.errors)
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
      response = UserRequest.put("/u/#{encode_email}/ccs/#{params[:nick]}", user_params.merge(params))
      OrdrIn::CreditCard.new(response.body.merge(params), response.errors)
    end

    def find_credit_card(nickname)
      response = UserRequest.get("/u/#{encode_email}/ccs/#{nickname}", user_params)
      OrdrIn::CreditCard.new(response.body, response.errors)
    end

    def find_all_credit_cards
      response = UserRequest.get("/u/#{encode_email}/ccs", user_params)
      response.body.values.collect do |credit_card_attributes|
        OrdrIn::CreditCard.new(credit_card_attributes, response.errors)
      end
    end

    def remove_credit_card(nickname)
      response = UserRequest.delete("/u/#{encode_email}/ccs/#{nickname}", user_params)
      OrdrIn::CreditCard.new(response.body).msg == "Credit Card Removed" ? true : false
    end

    # @param params [Hash]
    # @option params [String]  :rid Ordr.in's unique restaurant id
    # @option params [String]  :tray The tray is composed of menu items and
    #   optional sub-items. A single menu item's format is: [menu item
    #   id]/[qty],[option id],[option id]... Multiple menu items are joined by a
    #   +: [menu item id]/[qty]+[menu item id2]/[qty2] For example:
    #   3270/2+3263/1,3279 Means 2 of menu item 3270 (with no sub options) and 1
    #   of item num 3263 with sub option 3279.
    # @option params [String]  :tip tip amount in dollars and cents
    # @option params [String]  :delivery_date Either ASAP or in the date format
    #   2 digit month - 2 digit date, i.e. January 21 would be 01-21
    # @option params [String]  :delivery_time (Required if delivery_date is not
    #   ASAP) Format is 2 digit hour (24 hour time) and 2 digit minutes, i.e.
    #   9:30 PM would be 21:30.
    # @option params [String]  :first_name
    # @option params [String]  :last_name
    # @option params [String]  :addr
    # @option params [String]  :city
    # @option params [String]  :state
    # @option params [String]  :zip
    # @option params [String]  :phone
    # @option params [String]  :card_name
    # @option params [String]  :card_number
    # @option params [String]  :card_cvc
    # @option params [String]  :card_expiry
    # @option params [String]  :card_bill_addr
    # @option params [String]  :card_bill_addr2
    # @option params [String]  :card_bill_city
    # @option params [String]  :card_bill_state
    # @option params [String]  :card_bill_zip
    # @option params [String]  :card_bill_phone
    def place_order(params)
      response = OrderRequest.post("/o/#{params[:rid]}", user_params.merge(params))
      OrdrIn::Order.new(response.body, response.errors)
    end

    # @param params [Hash]
    # @option params [String]  :rid Ordr.in's unique restaurant id
    # @option params [String]  :tray The tray is composed of menu items and
    #   optional sub-items. A single menu item's format is: [menu item
    #   id]/[qty],[option id],[option id]... Multiple menu items are joined by a
    #   +: [menu item id]/[qty]+[menu item id2]/[qty2] For example:
    #   3270/2+3263/1,3279 Means 2 of menu item 3270 (with no sub options) and 1
    #   of item num 3263 with sub option 3279.
    # @option params [String]  :tip tip amount in dollars and cents
    # @option params [String]  :delivery_date Either ASAP or in the date format
    #   2 digit month - 2 digit date, i.e. January 21 would be 01-21
    # @option params [String]  :delivery_time (Required if delivery_date is not
    #   ASAP) Format is 2 digit hour (24 hour time) and 2 digit minutes, i.e.
    #   9:30 PM would be 21:30.
    # @option params [String]  :em
    # @option params [String]  :password optional.(Optional) If provided a new
    #   user accont will get created with the above email address.
    # @option params [String]  :first_name
    # @option params [String]  :last_name
    # @option params [String]  :addr
    # @option params [String]  :city
    # @option params [String]  :state
    # @option params [String]  :zip
    # @option params [String]  :phone
    # @option params [String]  :card_name
    # @option params [String]  :card_number
    # @option params [String]  :card_cvc
    # @option params [String]  :card_expiry
    # @option params [String]  :card_bill_addr
    # @option params [String]  :card_bill_addr2
    # @option params [String]  :card_bill_city
    # @option params [String]  :card_bill_state
    # @option params [String]  :card_bill_zip
    # @option params [String]  :card_bill_phone
    def place_guest_order(params)
      response = OrderRequest.post("/o/#{params[:rid]}", params)
      OrdrIn::Order.new(response.body, response.errors)
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
