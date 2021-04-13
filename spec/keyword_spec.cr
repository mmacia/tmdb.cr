require "./spec_helper"

describe Tmdb::Keyword do
  it "should get a keyword by its ID" do
    VCR.use_cassette("tmdb") do
      keyword = Tmdb::Keyword.detail(id: 679)

      keyword.should be_a(Tmdb::Keyword)
    end
  end

  context "#movies" do
    it "should get a movie list" do
      VCR.use_cassette("tmdb") do
        keyword = Tmdb::Keyword.detail(id: 679)
        movies = keyword.movies

        movies.total_items.should eq(143)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        keyword = Tmdb::Keyword.detail(id: 679)
        movies = keyword.movies(language: "es")

        movies.total_items.should eq(143)
      end
    end

    it "should filter by adult" do
      VCR.use_cassette("tmdb") do
        keyword = Tmdb::Keyword.detail(id: 679)
        movies = keyword.movies(include_adult: true)

        movies.total_items.should eq(143)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        keyword = Tmdb::Keyword.detail(id: 679)
        movies = keyword.movies

        movies.total_items.should eq(143)
        movies.each do |movie|
          movie.should be_a(Tmdb::MovieResult)
        end
      end
    end
  end
end
