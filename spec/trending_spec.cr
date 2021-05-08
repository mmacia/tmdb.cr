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

        movies.each do |movie|
          movie.should be_a(Tmdb::MovieResult)
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

        tv_shows.each do |tv_show|
          tv_show.should be_a(Tmdb::Tv::ShowResult)
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

        people.each do |person|
          person.should be_a(Tmdb::PersonResult)
        end
      end
    end
  end
end
