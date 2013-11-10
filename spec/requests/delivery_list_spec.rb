require 'spec_helper'

describe OrdrIn::DeliveryList do
  context "restaurants", :vcr do
    context "valid params" do
      it "returns list of restaurants" do
        restaurants = OrdrIn::DeliveryList.restaurants(date_time: "ASAP", address: "1 Main Street", zip_code: 77840, city: "College Station")
        restaurants.count.should == 53

        restaurant = restaurants.first
        restaurant.na.should == "Cafe Eccell"
        restaurant.full_addr.city.should == "College Station"
        restaurant.services.deliver.time.should == 45
      end
    end

    context "401" do
      it "raises UnauthorizedError"
    end
  end
end
