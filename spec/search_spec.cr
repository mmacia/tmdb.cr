require "./spec_helper"

describe Tmdb::Search do
  context "#movies" do
    it "should search movies" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator")

        movies.total_items.should eq(59)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end

    it "should iterate over all results" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator")

        movies.each do |movie|
          movie.should be_a(Tmdb::MovieResult)
        end
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator", language: "es")

        movies.total_items.should eq(59)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end

    it "should filter by adult" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator", include_adult: true)

        movies.total_items.should eq(60)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end

    it "should filter by region" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator", region: "it")

        movies.total_items.should eq(59)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end

    it "should filter by year" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator", year: 1984)

        movies.total_items.should eq(1)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end

    it "should filter by primary release year" do
      VCR.use_cassette("tmdb") do
        movies = Tmdb::Search.movies("terminator", primary_release_year: 1984)

        movies.total_items.should eq(1)
        movies.first.movie_detail.should be_a(Tmdb::Movie)
      end
    end
  end

  it "should search companies" do
    VCR.use_cassette("tmdb") do
      companies = Tmdb::Search.companies("icon films")

      companies.total_items.should eq(1)
      companies.first.company_detail.should be_a(Tmdb::Company)
    end
  end

  context "#collections" do
    it "should search collections" do
      VCR.use_cassette("tmdb") do
        collections = Tmdb::Search.collections("terminator")

        collections.total_items.should eq(3)
        collections.first.collection_detail.should be_a(Tmdb::Collection)
      end
    end

    it "should search collections by language" do
      VCR.use_cassette("tmdb") do
        collections = Tmdb::Search.collections("terminator", language: "es")

        collections.total_items.should eq(3)
        collections.first.collection_detail.should be_a(Tmdb::Collection)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        collections = Tmdb::Search.collections("terminator")

        collections.total_items.should eq(3)
        collections.each do |collection|
          collection.should be_a(Tmdb::CollectionResult)
        end
      end
    end
  end

  it "should search keywords" do
    VCR.use_cassette("tmdb") do
      keywords = Tmdb::Search.keywords("slum")

      keywords.total_items.should eq(7)
      keywords.each do |keyword|
        keyword.should be_a(Tmdb::Keyword)
      end
    end
  end

  context "#people" do
    it "should search people" do
      VCR.use_cassette("tmdb") do
        people = Tmdb::Search.people("eastwood")

        people.total_items.should eq(64)
      end
    end

    it "should search people by language" do
      VCR.use_cassette("tmdb") do
        people = Tmdb::Search.people("eastwood", language: "es")

        people.total_items.should eq(64)
      end
    end

    it "should search people by adult" do
      VCR.use_cassette("tmdb") do
        people = Tmdb::Search.people("eastwood", include_adult: true)

        people.total_items.should eq(66)
      end
    end

    it "should search people region" do
      VCR.use_cassette("tmdb") do
        people = Tmdb::Search.people("eastwood", region: "it")

        people.total_items.should eq(64)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        people = Tmdb::Search.people("eastwood")

        people.total_items.should eq(64)
        people.each do |person|
          person.should be_a(Tmdb::PersonResult)
        end
      end
    end
  end

  context "#tv_shows" do
    it "should search tv shows" do
      VCR.use_cassette("tmdb") do
        tv_shows = Tmdb::Search.tv_shows("the big bang theory")

        tv_shows.total_items.should eq(1)
      end
    end

    it "should search tv shows by language" do
      VCR.use_cassette("tmdb") do
        tv_shows = Tmdb::Search.tv_shows("the big bang theory", language: "es")

        tv_shows.total_items.should eq(1)
      end
    end

    it "should search tv shows by adult" do
      VCR.use_cassette("tmdb") do
        tv_shows = Tmdb::Search.tv_shows("the big bang theory", include_adult: true)

        tv_shows.total_items.should eq(1)
      end
    end

    it "should search tv shows by first air date year" do
      VCR.use_cassette("tmdb") do
        tv_shows = Tmdb::Search.tv_shows("the big bang theory", first_air_date_year: 2005)

        tv_shows.total_items.should eq(0)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        tv_shows = Tmdb::Search.tv_shows("the big bang theory")

        tv_shows.total_items.should eq(1)
        tv_shows.each do |tv_show|
          tv_show.should be_a(Tmdb::Tv::ShowResult)
        end
      end
    end
  end

  context "#multi" do
    it "should do a multi search" do
      VCR.use_cassette("tmdb") do
        results = Tmdb::Search.multi("karamazov")

        results.total_items.should eq(25)
        results.each do |result|
          result.should be_a(Tmdb::MovieResult | Tmdb::PersonResult | Tmdb::Tv::ShowResult)
        end
      end
    end
  end
end
