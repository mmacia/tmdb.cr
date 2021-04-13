require "./spec_helper"

describe Tmdb::Genre do
  context "#movie_list" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        genres = Tmdb::Genre.movie_list

        genres.size.should eq(19)
        genres.should be_a(Array(Tmdb::Genre))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        genres = Tmdb::Genre.movie_list(language: "es")

        genres.size.should eq(19)
        genres.should be_a(Array(Tmdb::Genre))
      end
    end
  end

  context "#tv_list" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        genres = Tmdb::Genre.tv_list

        genres.size.should eq(16)
        genres.should be_a(Array(Tmdb::Genre))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        genres = Tmdb::Genre.tv_list(language: "es")

        genres.size.should eq(16)
        genres.should be_a(Array(Tmdb::Genre))
      end
    end
  end
end
