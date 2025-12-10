require "./spec_helper"

describe Tmdb::WatchProvider do
  context "#available_regions" do
    it "should return a list of regions" do
      VCR.use_cassette "tmdb" do
        regions = Tmdb::WatchProvider.available_regions

        regions.size.should be > 1
        regions.should be_a(Array(Tmdb::Region))
      end
    end

    it "should return a translated list" do
      VCR.use_cassette "tmdb" do
        regions = Tmdb::WatchProvider.available_regions(language: "es")

        regions.size.should be > 1
        regions.should be_a(Array(Tmdb::Region))
      end
    end
  end

  context "#movie_providers" do
    it "should return a list of movie providers" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.movie_providers

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end

    it "should return a translated list of movie providers" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.movie_providers(language: "es")

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end

    it "should return a list of movie providers by region" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.movie_providers(watch_region: "us")

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end
  end

  context "#tv_providers" do
    it "should return a list of tv providers" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.tv_providers

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end

    it "should return a translated list of tv providers" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.tv_providers(language: "es")

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end

    it "should return a list of tv providers by region" do
      VCR.use_cassette "tmdb" do
        providers = Tmdb::WatchProvider.tv_providers(watch_region: "us")

        providers.size.should be > 1
        providers.should be_a(Array(Tmdb::Provider))
      end
    end
  end
end
