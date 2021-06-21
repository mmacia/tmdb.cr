require "./spec_helper"

describe Tmdb do
  it "should get version" do
    Tmdb::VERSION.should eq("0.1.5")
  end
end
