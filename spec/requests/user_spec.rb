require 'spec_helper'

describe OrdrIn::User do
  let(:email) { "austen.dev+ordrin@gmail.com" }
  let(:password) { "testing" }
  let(:user) { OrdrIn::User.new(email: email, password: password) }

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
      user.create_address(params).should be_true
    end

    it "doesn't create address" do
      expect { user.create_address({}) }.to raise_error(OrdrIn::NotFoundError)
    end
  end

  context "#all_addresses", :vcr do
    it "returns all addresses" do
      user.all_addresses.count.should > 0
    end
  end

  context "#address", :vcr do
    it "returns specific address" do
      address = user.address("Work")
      address.nick.should == "Work"
      address.zip.should == "11215"
    end
  end

  context "#remove_address", :vcr do
    it "returns true" do
      user.remove_address("test").should be_true
    end

    context "address doesn't exist" do
      it "returns true" do
        user.remove_address("nyan").should be_true
      end
    end
  end
end
