require "../spec_helper"

describe Tmdb::Tv::Season do
  context "#detail" do
    it "should get a season" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)

        season.should be_a(Tmdb::Tv::Season)
      end
    end

    it "should get translated data" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1, language: "es")

        season.should be_a(Tmdb::Tv::Season)
      end
    end
  end

  context "#aggregated_credits" do
    it "should get a list of credits" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        credits = season.aggregated_credits

        credits.should be_a(Array(Tmdb::Tv::AggregatedCast | Tmdb::Tv::AggregatedCrew))
        credits.size.should eq(101)
      end
    end

    it "should get translated list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        credits = season.aggregated_credits(language: "es")

        credits.should be_a(Array(Tmdb::Tv::AggregatedCast | Tmdb::Tv::AggregatedCrew))
        credits.size.should eq(101)
      end
    end
  end

  context "#changes" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        changes = season.changes(Time.utc(2016, 5, 20))

        changes.size.should eq(1)
        changes.should be_a(Array(Tmdb::Tv::Season::Change))
      end
    end
  end

  context "#credits" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        credits = season.credits(1418)

        credits.size.should eq(28)
        credits.should be_a(Array(Tmdb::Tv::Cast | Tmdb::Tv::Crew))
      end
    end
  end

  context "#external_ids" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        external_ids = season.external_ids

        external_ids.should be_a(Array(Tmdb::ExternalId))
        external_ids.size.should eq(1)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        external_ids = season.external_ids(language: "es")

        external_ids.should be_a(Array(Tmdb::ExternalId))
        external_ids.size.should eq(1)
      end
    end
  end

  context "#images" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        images = season.images

        images.should be_a(Array(Tmdb::Image))
        images.size.should eq(11)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        images = season.images(language: "es")

        images.should be_a(Array(Tmdb::Image))
        images.size.should eq(2)
      end
    end
  end

  context "#translations" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        translations = season.translations

        translations.size.should eq(48)
      end
    end

    it "should get translated data" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        translations = season.translations(language: "es")

        translations.size.should eq(48)
      end
    end
  end

  context "#videos" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        videos = season.videos

        videos.size.should eq(1)
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        season = Tmdb::Tv::Season.detail(1418, 1)
        videos = season.videos(language: "es")

        videos.size.should eq(0)
      end
    end
  end
end
