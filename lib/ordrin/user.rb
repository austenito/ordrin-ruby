module OrdrIn
  class User < Model
    attr_accessor :email, :password, :details

    def details
      return @details if @details
      url = "/u/#{encode_email}"
      @details = Hashie::Mash.new(UserRequest.get(url, user_params).body)
    end

    def create_account(params)
      Hashie::Mash.new(UserRequest.post("/u/#{encode_email}", user_params.merge(params)).body)
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
