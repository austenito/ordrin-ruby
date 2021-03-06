require 'spec_helper'

describe OrdrIn::Restaurant do
  context ".deliveries", :vcr do
    it "returns list of restaurants" do
      restaurants = OrdrIn::Restaurant.deliveries(date_time: "ASAP", address: "1 Main Street", 
                                                  zip_code: 77840, city: "College Station")
      restaurants.count.should == 53

      restaurant = restaurants.first
      restaurant.na.should == "Cafe Eccell"
      restaurant.full_addr.city.should == "College Station"
      restaurant.services.deliver.time.should == 45
    end
  end

  context "#details", :vcr do
    it "returns restaurant details" do
      details = OrdrIn::Restaurant.new(id: 147).details
      details.restaurant_id.should == "147"
      details.city.should == "College Station"
    end
  end

  context "#delivery_check" do
    it "returns delivery check", :vcr do
      restaurant = OrdrIn::Restaurant.new(id: 147)
      delivery_check = restaurant.delivery_check(date_time: "ASAP", address: "1 Main Street",
                                                  zip_code: 77840, city: "College Station")
      delivery_check.rid = 147
      delivery_check.meals = [0, 4]
    end
  end

  context "#delivery_fee" do
    it "returns delivery_fee", :vcr do
      restaurant = OrdrIn::Restaurant.new(id: 147)

      delivery_fee = restaurant.delivery_fee(subtotal: 20.42, tip: 5.05, date_time: "ASAP",
                                             address: "1 Main Street", zip_code: 77840, 
                                             city: "College Station")
      delivery_fee.rid = 147
      delivery_fee.tax = 2.01
    end
  end
end
