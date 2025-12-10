require "./spec_helper"

describe Tmdb::Configuration do
  it "should get configuration urls" do
    VCR.use_cassette("tmdb") do
      conf = Tmdb::Configuration.detail
      conf.should be_a(Tmdb::Configuration)
    end
  end

  it "should get a list of countries" do
    VCR.use_cassette("tmdb") do
      countries = Tmdb::Configuration.countries
      countries.should be_a(Array(Tmdb::Country))
      countries.size.should be > 1
    end
  end

  it "should get a list of jobs" do
    VCR.use_cassette("tmdb") do
      jobs = Tmdb::Configuration.jobs
      jobs.should be_a(Hash(String, Array(String)))
      jobs.size.should be > 1
    end
  end

  it "should return a list of languages" do
    VCR.use_cassette("tmdb") do
      languages = Tmdb::Configuration.languages
      languages.should be_a(Array(Tmdb::Language))
      languages.size.should be > 1
    end
  end

  it "should get a list of primary translations" do
    VCR.use_cassette("tmdb") do
      translations = Tmdb::Configuration.primary_translations
      translations.should be_a(Array(String))
      translations.size.should be > 1
    end
  end

  it "should get a list of timezones" do
    VCR.use_cassette("tmdb") do
      timezones = Tmdb::Configuration.timezones
      timezones.should be_a(Hash(String, Array(String)))
      timezones.size.should be > 1
    end
  end
end
