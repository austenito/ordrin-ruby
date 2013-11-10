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
end
