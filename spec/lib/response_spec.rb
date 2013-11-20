require 'spec_helper' 

describe OrdrIn::Response do
  context "with errors" do
    let(:error_body) do
      { "_err"=>1,
        "err_code"=>400,
        "_msg"=>
          { "_err"=>1,
            "_msg"=>
            "Expiration date is required.",
            "_status"=>400
          }
      }.to_json
    end
    let(:request) { stub }

    it "stores errors" do
      http_response = stub(status: 400, body: error_body)
      response = OrdrIn::Response.new(request, http_response)
      response.errors?.should be_true
      response.errors.msg.should == "Expiration date is required."
    end
  end

  context "#errors?" do
    let(:request) { stub }

    it "stores errors" do
      http_response = stub(status: 400, body: {})
      response = OrdrIn::Response.new(request, http_response)
      response.errors?.should be_false
    end
  end

  context "#check_response" do
    let(:request) { stub }
    context "200 response" do
      it "doesn't raise an error" do
        response = stub(status: 200, body: {})
        OrdrIn::Response.new(request, response)
      end
    end

    context "400 response" do
      it "doesn't raise an error" do
        response = stub(status: 400, body: {})
        OrdrIn::Response.new(request, response)
      end
    end

    context "401 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 401, body: {})
        expect { OrdrIn::Response.new(request, response) }.to raise_error(OrdrIn::UnauthorizedError)
      end
    end

    context "404 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 404)
        expect { OrdrIn::Response.new(request, response) }.to raise_error(OrdrIn::NotFoundError)
      end
    end

    context "500 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 500)
        expect { OrdrIn::Response.new(request, response) }.to raise_error(OrdrIn::ServerError)
      end

      it "raises UnauthorizedError" do
        response = stub(status: 505)
        expect { OrdrIn::Response.new(request, response) }.to raise_error(OrdrIn::ServerError)
      end
    end
  end

  context "#body" do
    let(:request) { stub }

    context "valid JSON" do
      it "returns hash" do
        http_response = stub(status: 200, body: "{\"foo\": \"bar\"}")
        response = OrdrIn::Response.new(request, http_response) 
        response.body["foo"].should == "bar"
      end
    end

    context "invalid JSON" do
      it "raises ParserError" do
        http_response = stub(status: 200, body: "'foo': bar")
        expect { OrdrIn::Response.new(request, http_response).body }.to raise_error(JSON::ParserError)
      end
    end
  end
end
