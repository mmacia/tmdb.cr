require "./spec_helper"

describe Tmdb::Movie do
  context "#alternative_titles" do
    it "should get alternative titles" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        titles = movie.alternative_titles

        titles.size.should eq(21)
        titles.should be_a(Array(Tmdb::AlternativeTitle))
      end
    end

    it "should filter by country" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        titles = movie.alternative_titles(country: "mx")

        titles.size.should eq(1)
        titles.should be_a(Array(Tmdb::AlternativeTitle))
      end
    end
  end

  context "#cast" do
    it "should get cast" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        credits = movie.cast

        credits.size.should eq(49)
        credits.should be_a(Array(Tmdb::CastCredit))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        credits = movie.cast(language: "es")

        credits.size.should eq(49)
        credits.should be_a(Array(Tmdb::CastCredit))
      end
    end
  end

  context "#crew" do
    it "should get crew" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        credits = movie.crew

        credits.size.should eq(77)
        credits.should be_a(Array(Tmdb::CrewCredit))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        credits = movie.crew(language: "es")

        credits.size.should eq(77)
        credits.should be_a(Array(Tmdb::CrewCredit))
      end
    end
  end

  it "should get external IDs" do
    VCR.use_cassette("tmdb") do
      movie = Tmdb::Movie.detail(218)
      external_ids = movie.external_ids

      external_ids.size.should eq(2)
      external_ids.should be_a(Array(Tmdb::Movie::ExternalId))
    end
  end

  context "#backdrops" do
    it "should get backdrops" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        backdrops = movie.backdrops

        backdrops.size.should eq(8)
        backdrops.should be_a(Array(Tmdb::Image))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        backdrops = movie.backdrops(language: "es")

        backdrops.size.should eq(0)
        backdrops.should be_a(Array(Tmdb::Image))
      end
    end

    it "should include image language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        backdrops = movie.backdrops(include_image_language: ["es", "en"])

        backdrops.size.should eq(8)
        backdrops.should be_a(Array(Tmdb::Image))
      end
    end
  end

  context "#posters" do
    it "should get posters" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        posters = movie.posters

        posters.size.should eq(27)
        posters.should be_a(Array(Tmdb::Image))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        posters = movie.posters(language: "es")

        posters.size.should eq(7)
        posters.should be_a(Array(Tmdb::Image))
      end
    end

    it "should include image language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        posters = movie.posters(include_image_language: ["es", "en"])

        posters.size.should eq(34)
        posters.should be_a(Array(Tmdb::Image))
      end
    end
  end

  it "should get keywords" do
    VCR.use_cassette("tmdb") do
      movie = Tmdb::Movie.detail(218)
      keywords = movie.keywords

      keywords.size.should eq(12)
      keywords.should be_a(Array(Tmdb::Keyword))
    end
  end

  context "#recommendations" do
    it "should get recommendations" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        recommendations = movie.recommendations

        recommendations.total_items.should eq(40)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        recommendations = movie.recommendations(language: "es")

        recommendations.total_items.should eq(40)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        recommendations = movie.recommendations(language: "es")

        recommendations.total_items.should eq(40)
        recommendations.each do |recommendation|
          recommendation.should be_a(Tmdb::MovieResult)
        end
      end
    end
  end

  it "should get release dates" do
    VCR.use_cassette("tmdb") do
      movie = Tmdb::Movie.detail(218)
      release_dates = movie.release_dates

      release_dates.size.should eq(32)
      release_dates.should be_a(Array(Tuple(String, Array(Tmdb::Release))))
    end
  end

  context "#user_review" do
    it "should get user reviews" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        user_reviews = movie.user_reviews

        user_reviews.total_items.should eq(4)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        user_reviews = movie.user_reviews(language: "es")

        user_reviews.total_items.should eq(0)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        user_reviews = movie.user_reviews

        user_reviews.total_items.should eq(4)
        user_reviews.each do |user_review|
          user_review.should be_a(Tmdb::Review)
        end
      end
    end
  end

  context "#similar_movies" do
    it "should get similar movies" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        similar_movies = movie.similar_movies

        similar_movies.total_items.should eq(134)
      end
    end

    it "should filter by language" do
        movie = Tmdb::Movie.detail(218)
        similar_movies = movie.similar_movies(language: "es")

        similar_movies.total_items.should eq(134)
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        similar_movies = movie.similar_movies

        similar_movies.total_items.should eq(134)
        similar_movies.each do |user_review|
          user_review.should be_a(Tmdb::MovieResult)
        end
      end
    end
  end

  it "should get translations" do
    VCR.use_cassette("tmdb") do
      movie = Tmdb::Movie.detail(218)
      translations = movie.translations

      translations.size.should eq(44)
    end
  end

  context "#videos" do
    it "should get videos" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        videos = movie.videos

        videos.size.should eq(1)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        movie = Tmdb::Movie.detail(218)
        videos = movie.videos(language: "es")

        videos.size.should eq(1)
      end
    end
  end

  it "should get watch providers" do
    VCR.use_cassette("tmdb") do
      movie = Tmdb::Movie.detail(218)
      watch_providers = movie.watch_providers

      watch_providers.size.should eq(44)
    end
  end
end
