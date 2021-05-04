require "./spec_helper"

describe Tmdb::Collection do
  it "should get collection parts" do
    VCR.use_cassette("tmdb") do
      collection = Tmdb::Collection.detail(528)
      parts = collection.parts

      parts.size.should eq(6)
      parts.should be_a(Array(Tmdb::MovieResult))
    end
  end

  it "should get overview" do
    VCR.use_cassette("tmdb") do
      collection = Tmdb::Collection.detail(528)
      overview = collection.overview

      overview.should be_a(String)
    end
  end

  context "#backdrops" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        backdrops = collection.backdrops

        backdrops.size.should eq(4)
        backdrops.should be_a(Array(Tmdb::Backdrop))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        backdrops = collection.backdrops(language: "es")

        backdrops.size.should eq(0)
        backdrops.should be_a(Array(Tmdb::Backdrop))
      end
    end

    it "should get image URL" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        backdrops = collection.backdrops

        backdrops.each do |backdrop|
          backdrop.image_url.should be_a(String)
        end
      end
    end
  end

  context "#posters" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        posters = collection.posters

        posters.size.should eq(18)
        posters.should be_a(Array(Tmdb::Poster))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        posters = collection.posters(language: "es")

        posters.size.should eq(3)
        posters.should be_a(Array(Tmdb::Poster))
      end
    end

    it "should get image URL" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        posters = collection.posters

        posters.each do |poster|
          poster.image_url.should be_a(String)
        end
      end
    end
  end

  context "#translations" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        translations = collection.translations

        translations.size.should eq(32)
        translations.should be_a(Array(Tmdb::Translation))
      end
    end

    it "should filter by language" do
      VCR.use_cassette("tmdb") do
        collection = Tmdb::Collection.detail(528)
        translations = collection.translations(language: "es")

        translations.size.should eq(32)
        translations.should be_a(Array(Tmdb::Translation))
      end
    end
  end
end
