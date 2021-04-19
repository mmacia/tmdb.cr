require "./spec_helper"

describe Tmdb::TVShow do
  context "#detail" do
    it "should get a TV Show from ID" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::TVShow.detail(31132)

        tv_show.should be_a(Tmdb::TVShow)
      end
    end

    it "should get translated data" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::TVShow.detail(31132, language: "es")

        tv_show.should be_a(Tmdb::TVShow)
      end
    end
  end
end
