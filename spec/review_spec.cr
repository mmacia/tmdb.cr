require "./spec_helper"

describe Tmdb::Review do
  it "should get a review by its ID" do
    VCR.use_cassette("tmdb") do
      review = Tmdb::Review.detail(id: "5f20ce845b2f4700364b2000")

      review.should be_a(Tmdb::Review)
    end
  end
end
