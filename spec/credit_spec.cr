require "./spec_helper"

describe Tmdb::Credit do
  it "should get a credit" do
    VCR.use_cassette("tmdb") do
      credit = Tmdb::Credit.detail "52fe4228c3a36847f800851f"

      credit.should be_a(Tmdb::Credit)
    end
  end
end
