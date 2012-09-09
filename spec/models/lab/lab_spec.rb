require "spec_helper"

describe Lab do
  it "has a valid factory" do
    FactoryGirl.build(:lab).should be_valid
  end
end
