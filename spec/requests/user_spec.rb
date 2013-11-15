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
end
