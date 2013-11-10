require 'spec_helper'

describe OrdrIn::Request do
  context ".get" do
    it  "sends get" do
      response = stub
      connection = stub(send: response)
      OrdrIn::Request.stubs(:check_response)
      Faraday.stubs(:new).returns(connection)

      OrdrIn::Request.get("path")

      connection.should have_received(:send).with(:get, "path")
      OrdrIn::Request.should have_received(:check_response).with(response)
    end
  end

  context ".check_response" do
    context "200 response" do
      it "returns nil" do
        response = stub(status: 200)
        OrdrIn::Request.check_response(response).should be_nil
      end
    end

    context "401 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 401)
        expect { OrdrIn::Request.check_response(response) }.to raise_error(OrdrIn::UnauthorizedError)
      end
    end

    context "404 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 404)
        expect { OrdrIn::Request.check_response(response) }.to raise_error(OrdrIn::NotFoundError)
      end
    end

    context "500 response" do
      it "raises UnauthorizedError" do
        response = stub(status: 500)
        expect { OrdrIn::Request.check_response(response) }.to raise_error(OrdrIn::ServerError)
      end
    end
  end
end
