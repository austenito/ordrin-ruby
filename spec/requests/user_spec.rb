require 'spec_helper'

describe OrdrIn::User do
  let(:email) { "austen.dev+ordrin@gmail.com" }
  let(:password) { "testing" }

  context ".create_account", :vcr do
    it "creates account" do
      user = OrdrIn::User.new(email: "austen.dev+ordrin2@gmail.com", password: password)
      response = user.create_account(first_name: "Nyan", last_name: "Cat")
      response.msg.should == "user saved"
      response.user_id.should_not be_nil
    end
  end
  
  context "#details", :vcr do
    it "returns details" do
      user = OrdrIn::User.new(email: email, password: password)
      details = user.details
      details.em = "austen.dev+ordrin@gmail.com"
      details.first_name = "Austen"
    end
  end

  context "#create_address", :vcr do
    let(:params) do
      { nick: "nickname",
        addr: "456 Carroll Street",
        city: "Brooklyn",
        state: "NY",
        zip: 11215,
        phone: "808-123-4567"
      }
    end

    it "creates address" do
      user = OrdrIn::User.new(email: email, password: password)
      user.create_address(params).should be_true
    end
  end
end
