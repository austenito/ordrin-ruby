require 'spec_helper'

describe OrdrIn::Request do
  context ".get" do
    it  "sends get" do
      response = stub
      OrdrIn::Response.stubs(:new).returns(response)
      connection = stub(send: response)
      Faraday.stubs(:new).returns(connection)

      return_value = OrdrIn::Request.get("path")

      connection.should have_received(:send).with(:get, "path")
      return_value.should == response
    end
  end
end
