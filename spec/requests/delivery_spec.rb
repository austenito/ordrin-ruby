require 'spec_helper'

describe OrdrIn::Delivery do
  context ".check", :vcr do
    it "returns delivery check status" do
      delivery_check = OrdrIn::Delivery.check(147, date_time: "ASAP", address: "1 Main Street", 
                                              zip_code: 77840, city: "College Station")
      delivery_check.rid = 147
      delivery_check.meals = [0, 4]
    end
  end

  context ".fee", :vcr do
    it "returns delivery fee" do
      delivery_fee = OrdrIn::Delivery.fee(147, subtotal: 20.42, tip: 5.05, date_time: "ASAP", 
                                            address: "1 Main Street", zip_code: 77840, 
                                            city: "College Station")
      delivery_fee.rid = 147
      delivery_fee.tax = 2.01
    end
  end
end
