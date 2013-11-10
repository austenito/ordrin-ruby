require 'spec_helper' 

describe OrdrIn::Response do
  context "#check_response" do
    let(:request) { stub }
    context "200 response" do
      it "doesn't raise an error" do
        response = stub(status: 200)
        OrdrIn::Response.new(request, response)
      end
    end

    context "401 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 401)
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
