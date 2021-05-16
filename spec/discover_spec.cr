require "./spec_helper"

describe Tmdb::Discover do
  context "#movies" do
    qb = Tmdb::Discover::QueryBuilder.new
      .certification_country("us")
      .certification("R")
      .primary_release_year(2015)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        movies = Tmdb::Discover.movies(qb.to_filter)

        movies.total_items.should eq(344)
      end
    end

    it "should iterate over each item" do
      VCR.use_cassette "tmdb" do
        movies = Tmdb::Discover.movies(qb.to_filter)
        skip_at = 100

        movies.each do |movie|
          skip_at -= 1
          movie.should be_a(Tmdb::MovieResult)

          break if skip_at <= 0
        end
      end
    end
  end

  context "#tv_shows" do
    qb = Tmdb::Discover::QueryBuilder.new
      .first_air_date_year(2015)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        tv_shows = Tmdb::Discover.tv_shows(qb.to_filter)

        tv_shows.total_items.should eq(3421)
      end
    end

    it "should iterate over each item" do
      VCR.use_cassette "tmdb" do
        tv_shows = Tmdb::Discover.tv_shows(qb.to_filter)
        skip_at = 100

        tv_shows.each do |tv_show|
          skip_at -= 1
          tv_show.should be_a(Tmdb::Tv::ShowResult)

          break if skip_at <= 0
        end
      end
    end
  end
end
