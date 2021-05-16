require "./spec_helper"

describe Tmdb::Trending do
  context "#trending_movies" do
    it "should return a list of daily trends" do
      VCR.use_cassette "tmdb" do
        movies = Tmdb::Trending.trending_movies(Tmdb::Trending::TimeWindow::Day)

        movies.should be_a(Tmdb::LazyIterator(Tmdb::MovieResult))
        movies.total_items.should eq(20_000)
      end
    end

    it "should return a list of weekly trends" do
      VCR.use_cassette "tmdb" do
        movies = Tmdb::Trending.trending_movies(Tmdb::Trending::TimeWindow::Week)

        movies.should be_a(Tmdb::LazyIterator(Tmdb::MovieResult))
        movies.total_items.should eq(20_000)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        movies = Tmdb::Trending.trending_movies(Tmdb::Trending::TimeWindow::Day)
        skip_at = 100

        movies.each do |movie|
          skip_at =- 1
          movie.should be_a(Tmdb::MovieResult)

          break if skip_at <= 0
        end
      end
    end
  end

  context "#trending_tv_shows" do
    it "should return a list of daily trends" do
      VCR.use_cassette "tmdb" do
        tv_shows = Tmdb::Trending.trending_tv_shows(Tmdb::Trending::TimeWindow::Day)

        tv_shows.should be_a(Tmdb::LazyIterator(Tmdb::Tv::ShowResult))
        tv_shows.total_items.should eq(20_000)
      end
    end

    it "should return a list of weekly trends" do
      VCR.use_cassette "tmdb" do
        tv_shows = Tmdb::Trending.trending_tv_shows(Tmdb::Trending::TimeWindow::Week)

        tv_shows.should be_a(Tmdb::LazyIterator(Tmdb::Tv::ShowResult))
        tv_shows.total_items.should eq(20_000)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        tv_shows = Tmdb::Trending.trending_tv_shows(Tmdb::Trending::TimeWindow::Day)
        skip_at = 100

        tv_shows.each do |tv_show|
          skip_at =- 1
          tv_show.should be_a(Tmdb::Tv::ShowResult)

          break if skip_at <= 0
        end
      end
    end
  end

  context "#trending_people" do
    it "should return a list of daily trends" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Trending.trending_people(Tmdb::Trending::TimeWindow::Day)

        people.should be_a(Tmdb::LazyIterator(Tmdb::PersonResult))
        people.total_items.should eq(20_000)
      end
    end

    it "should return a list of weekly trends" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Trending.trending_people(Tmdb::Trending::TimeWindow::Week)

        people.should be_a(Tmdb::LazyIterator(Tmdb::PersonResult))
        people.total_items.should eq(20_000)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Trending.trending_people(Tmdb::Trending::TimeWindow::Day)
        skip_at = 0

        people.each do |person|
          skip_at =- 1
          person.should be_a(Tmdb::PersonResult)

          break if skip_at <= 0
        end
      end
    end
  end
end
