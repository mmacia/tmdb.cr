require "../spec_helper"

describe Tmdb::Tv::Show do
  context "#detail" do
    it "should get a TV Show from ID" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)

        tv_show.should be_a(Tmdb::Tv::Show)
      end
    end

    it "should get translated data" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132, language: "es")

        tv_show.should be_a(Tmdb::Tv::Show)
      end
    end
  end

  context "#aggregated_credits" do
    it "should get a list of credits" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        credits = tv_show.aggregated_credits

        credits.should be_a(Array(Tmdb::Tv::AggregatedCast | Tmdb::Tv::AggregatedCrew))
        credits.size.should eq(42)
      end
    end

    it "should get translated list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        credits = tv_show.aggregated_credits(language: "es")

        credits.should be_a(Array(Tmdb::Tv::AggregatedCast | Tmdb::Tv::AggregatedCrew))
        credits.size.should eq(42)
      end
    end
  end

  context "#alternative_titles" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        titles = tv_show.alternative_titles

        titles.should be_a(Array(Tmdb::AlternativeTitle))
        titles.size.should eq(2)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        titles = tv_show.alternative_titles(language: "es")

        titles.should be_a(Array(Tmdb::AlternativeTitle))
        titles.size.should eq(2)
      end
    end
  end

  context "#content_ratings" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        ratings = tv_show.content_ratings

        ratings.should be_a(Array(Tmdb::Tv::Rating))
        ratings.size.should eq(4)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        ratings = tv_show.content_ratings(language: "es")

        ratings.should be_a(Array(Tmdb::Tv::Rating))
        ratings.size.should eq(4)
      end
    end
  end

  context "#episode_groups" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        episode_groups = tv_show.episode_groups

        episode_groups.should be_a(Array(Tmdb::Tv::EpisodeGroupResult))
        episode_groups.size.should eq(0)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        episode_groups = tv_show.episode_groups(language: "es")

        episode_groups.should be_a(Array(Tmdb::Tv::EpisodeGroupResult))
        episode_groups.size.should eq(0)
      end
    end
  end

  context "#external_ids" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        external_ids = tv_show.external_ids

        external_ids.should be_a(Array(Tmdb::ExternalId))
        external_ids.size.should eq(4)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        external_ids = tv_show.external_ids(language: "es")

        external_ids.should be_a(Array(Tmdb::ExternalId))
        external_ids.size.should eq(4)
      end
    end
  end

  context "#backdrops" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        backdrops = tv_show.backdrops

        backdrops.should be_a(Array(Tmdb::Backdrop))
        backdrops.size.should eq(3)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        backdrops = tv_show.backdrops(language: "es")

        backdrops.should be_a(Array(Tmdb::Backdrop))
        backdrops.size.should eq(0)
      end
    end
  end

  context "#posters" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        posters = tv_show.posters

        posters.should be_a(Array(Tmdb::Poster))
        posters.size.should eq(7)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        posters = tv_show.posters(language: "es")

        posters.should be_a(Array(Tmdb::Poster))
        posters.size.should eq(0)
      end
    end
  end

  context "#keywords" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        keywords = tv_show.keywords

        keywords.should be_a(Array(Tmdb::Keyword))
        keywords.size.should eq(8)
      end
    end
  end

  context "#recommendations" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        recommendations = tv_show.recommendations

        recommendations.total_items.should eq(40)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        recommendations = tv_show.recommendations(language: "es")

        recommendations.total_items.should eq(40)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        recommendations = tv_show.recommendations(language: "es")

        recommendations.each do |recommendation|
          recommendation.should be_a(Tmdb::Tv::ShowResult)
        end
      end
    end
  end

  context "#reviews" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        reviews = tv_show.reviews

        reviews.total_items.should eq(0)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        reviews = tv_show.reviews(language: "es")

        reviews.total_items.should eq(0)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        reviews = tv_show.reviews

        reviews.each do |review|
          review.should be_a(Tmdb::Review)
        end
      end
    end
  end

  context "#similar_tv_shows" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        similar = tv_show.similar_tv_shows

        similar.total_items.should eq(84)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        similar = tv_show.similar_tv_shows(language: "es")

        similar.total_items.should eq(84)
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        similar = tv_show.similar_tv_shows

        similar.each do |review|
          review.should be_a(Tmdb::Tv::ShowResult)
        end
      end
    end
  end

  context "#translations" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        translations = tv_show.translations

        translations.should be_a(Array(Tmdb::Tv::Translation))
        translations.size.should eq(19)
      end
    end
  end

  context "#videos" do
    it "should get videos" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        videos = tv_show.videos

        videos.size.should eq(1)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        videos = tv_show.videos(language: "es")

        videos.size.should eq(0)
      end
    end
  end

  context "#watch_providers" do
    it "should get watch providers" do
      VCR.use_cassette("tmdb") do
        tv_show = Tmdb::Tv::Show.detail(31132)
        watch_providers = tv_show.watch_providers

        watch_providers.size.should eq(21)
      end
    end
  end
end
