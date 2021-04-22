require "../spec_helper"

describe Tmdb::Tv::Episode do
  context "#detail" do
    it "should get an episode" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)

        episode.should be_a(Tmdb::Tv::Episode)
      end
    end

    it "should get a translated episode" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1, language: "es")

        episode.should be_a(Tmdb::Tv::Episode)
      end
    end
  end

  context "#crew" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        crew = episode.crew

        crew.should be_a(Array(Tmdb::Tv::Crew))
        crew.size.should eq(31)
      end
    end
  end

  context "#guest_stars" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        guest_stars = episode.guest_stars

        guest_stars.should be_a(Array(Tmdb::Tv::GuestStar))
        guest_stars.size.should eq(2)
      end
    end
  end

  context "#credits" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        credits = episode.credits

        credits.should be_a(Array(Tmdb::Tv::Crew | Tmdb::Tv::Cast | Tmdb::Tv::GuestStar))
        credits.size.should eq(33)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        credits = episode.credits(language: "es")

        credits.should be_a(Array(Tmdb::Tv::Crew | Tmdb::Tv::Cast | Tmdb::Tv::GuestStar))
        credits.size.should eq(33)
      end
    end
  end

  context "#external_ids" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        external_ids = episode.external_ids

        external_ids.should be_a(Array(Tmdb::ExternalId))
        external_ids.size.should eq(2)
      end
    end
  end

  context "#images" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        images = episode.images

        images.should be_a(Array(Tmdb::Image))
        images.size.should eq(2)
      end
    end
  end

  context "#translations" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        translations = episode.translations

        translations.should be_a(Array(Tmdb::Tv::Translation))
        translations.size.should eq(48)
      end
    end
  end

  context "#videos" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        videos = episode.videos

        videos.should be_a(Array(Tmdb::Video))
        videos.size.should eq(0)
      end
    end

    it "should get a translated list" do
      VCR.use_cassette("tmdb") do
        episode = Tmdb::Tv::Episode.detail(1418, 1, 1)
        videos = episode.videos(language: "es")

        videos.should be_a(Array(Tmdb::Video))
        videos.size.should eq(0)
      end
    end
  end
end
