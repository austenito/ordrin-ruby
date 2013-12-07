require 'spec_helper'

describe OrdrIn::User do
  let(:email) { "austen.dev+ordrin@gmail.com" }
  let(:password) { "testing" }
  let(:user) { OrdrIn::User.new(email: email, password: password) }

  context ".create_account", :vcr do
    it "returns user" do
      user = OrdrIn::User.create_account(email: "austen.dev+ordrin2@gmail.com", password: password,
                              first_name: "Nyan", last_name: "Cat")
      user.msg.should == "user saved"
      user.user_id.should_not be_nil
      user.first_name.should == "Nyan"
      user.last_name.should == "Cat"
    end

    context "missing params" do
      it "has no errors" do
        user = OrdrIn::User.create_account(email: "austen.dev+ordrin2@gmail.com", password: password)
        user.errors?.should be_false
      end
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
      address = user.create_address(params)
      address.city.should == "Brooklyn"
    end

    it "doesn't create address" do
      expect { user.create_address({}) }.to raise_error(OrdrIn::NotFoundError)
    end

    context "with missing params", :vcr do
      it "doesn't return error" do
        address = user.create_address(nick: "nyan")
        address.errors?.should be_false
      end
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

  context "#create_credit_card", :vcr do
    let(:credit_card_params) do
      {
        nick: "nickname",
        name: "Nyan Cat Black Card",
        number: "4242424242424242",
        cvc: 123,
        expiry_month: "02",
        expiry_year: "2042",
        type: "Visa",
        bill_addr: "456 Carroll St.",
        bill_city: "Brooklyn",
        bill_state: "NY",
        bill_zip: "11215",
        bill_phone: "808-123-4567"
      }
    end

    it "returns credit card" do
      credit_card = user.create_credit_card(credit_card_params)
      credit_card.type.should == "Visa"
      credit_card.errors.should be_false
    end

    context "failed to create credit card" do
      it "returns errors" do
        credit_card_params.delete(:expiry_year)
        credit_card = user.create_credit_card(credit_card_params)
        credit_card.errors?.should be_true
        puts credit_card.errors
      end
    end
  end

  context "#remove_credit_card", :vcr do
    it "removes credit card" do
       user.remove_credit_card("Work").should be_true
    end

    it "raises not found error" do
       expect { user.remove_credit_card("123455") }.to raise_error(OrdrIn::NotFoundError)
    end
  end

  context "#find_credit_card", :vcr do
    it "returns credit card" do
      credit_card = user.find_credit_card("nickname")
      credit_card.nick == "nickname"
      credit_card.type == "Visa"
    end

    it "raises not found error" do
       expect { user.find_credit_card("123455") }.to raise_error(OrdrIn::NotFoundError)
    end
  end

  context "#find_all_credit_cards", :vcr do
    it "returns credit cards" do
      credit_cards = user.find_all_credit_cards
      credit_cards.count.should == 2
      credit_cards.first.nick.should == "Nyan"
      credit_cards.last.nick.should == "nickname"
    end
  end

  context "#place_order", :vcr, record: :all do
    let(:params) do
      {
        rid: 147,
        tray: "4622236/1,4622238+4622296/1,+4622370/1",
        tip: "5.05",
        delivery_date: Time.now.strftime("%m-%d"),
        delivery_time: "16:00",
        first_name: "Nyan",
        last_name: "Cat",
        addr: "1 Main Street",
        city: "College Station",
        state: "TX",
        zip: "77840",
        phone: "808-123-4567",
        card_name: "Nyan Black Card",
        card_number: "4111111111111111",
        card_cvc: "123",
        card_expiry: "02/2016",
        card_bill_addr: "456 Carroll St.",
        card_bill_city: "Brooklyn",
        card_bill_state: "NY",
        card_bill_zip: "11215",
        card_bill_phone: "808-123-4567"
      }
    end

    context "valid params" do
      it "places order" do
        order = user.place_order(params)
        order.errors?.should be_false
        order.state.should == "NY"
      end
    end

    context "invalid params" do
      it "doesn't places order" do
        params.delete(:zip)
        order = user.place_order(params)
        order.errors?.should be_true
        order.errors.msg.should =~ /invalid zip/
      end
    end
  end

  context "#place_guest_order", :vcr do
    let(:params) do
      {
        rid: 147,
        tray: "4622236/1,4622238+4622296/1",
        tip: "5.05",
        delivery_date: Time.now.strftime("%m-%d"),
        delivery_time: "16:00",
        first_name: "Nyan",
        last_name: "Cat",
        addr: "1 Main Street",
        city: "College Station",
        state: "TX",
        zip: "77840",
        phone: "808-123-4567",
        card_name: "Nyan Black Card",
        card_number: "4111111111111111",
        card_cvc: "123",
        card_expiry: "02/2016",
        card_bill_addr: "456 Carroll St.",
        card_bill_city: "Brooklyn",
        card_bill_state: "NY",
        card_bill_zip: "11215",
        card_bill_phone: "808-123-4567"
      }
    end

    context "valid params" do
      it "places order" do
        order = user.place_order(params.merge(em: "nyan@cat.com"))
        order.errors?.should be_false
        order.cs_order_id.should == "9999999999"
      end
    end

    context "invalid params" do
      it "doesn't place order" do
        order = user.place_order(params)
        order.errors?.should be_true
      end
    end
  end
end
