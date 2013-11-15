module OrdrIn
  class User < Model
    attr_accessor :email, :password, :details

    def initialize(email, password)
      @email = email
      @password = password
    end

    def details
      return @details if @details
      url = "/u/#{CGI.escape(email)}"
      @details = Hashie::Mash.new(UserRequest.get(url, email: email, password: password).body)
    end

    def self.create_account(params)
      UserRequest.post("/u/#{params[:email]}", params)
    end
  end
end
