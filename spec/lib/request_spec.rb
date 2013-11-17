require 'spec_helper'

describe OrdrIn::Request do
  context "#send_request" do
    let(:request) { Hashie::Mash.new }

    before(:each) do
      OrdrIn::Response.stubs(:new).returns({})
      connection = stub
      connection.stubs(:send).yields(request)
      Faraday.stubs(:new).returns(connection)
    end

    it "sets client authentication" do
      OrdrIn::Request.get("path")
      request["X-NAAMA-CLIENT-AUTHENTICATION"].should == "id=#{OrdrIn::Config.api_key}, version=1"
    end

      it "sets user authentication" do
        OrdrIn::Request.post("path", email: "nyan@cat.com", password: "rainbow")
        hashed_password = Digest::SHA256.new.hexdigest("rainbow")
        hash_code = Digest::SHA256.new.hexdigest("#{hashed_password}nyan@cat.compath")
        request["X-NAAMA-AUTHENTICATION"].should == "username=\"nyan@cat.com\", response=\"#{hash_code}\", version=\"1\""
    end

      it "sets body" do
        OrdrIn::Request.post("path", nyan: :cat)
        request.body.should == { nyan: :cat }.to_json
      end
  end

  context "CRUD actions" do
    let(:response) { stub }
    let(:connection) { stub(send: response) }

    before(:each) do
      OrdrIn::Response.stubs(:new).returns(response)
      Faraday.stubs(:new).returns(connection)
    end

    context ".get" do
      it  "receives response" do
        return_value = OrdrIn::Request.get("path")
        connection.should have_received(:send).with(:get, "path")
        return_value.should == response
      end
    end

    context ".post" do
      it "receives response" do
        return_value = OrdrIn::Request.post("path", nyan: :cat)
        connection.should have_received(:send).with(:post, "path")
        return_value.should == response
      end
    end

    context ".put" do
      it "receives response" do
        return_value = OrdrIn::Request.put("path", nyan: :cat)
        connection.should have_received(:send).with(:put, "path")
        return_value.should == response
      end
    end
  end
end
