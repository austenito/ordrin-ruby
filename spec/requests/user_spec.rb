require 'spec_helper'

describe OrdrIn::User do
  let(:email) { "austen.dev+ordrin@gmail.com" }
  let(:password) { "testing" }

  context "#details", :vcr, record: :all do
    it "returns details" do
      user = OrdrIn::User.new(email, password)
      details = user.details
      details.em = "austen.dev+ordrin@gmail.com"
      details.first_name = "Austen"
    end
  end
end
