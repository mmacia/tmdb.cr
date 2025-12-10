require "./spec_helper"

describe Tmdb::Network do
  context "#detail" do
    it "should get a network instance" do
      VCR.use_cassette("tmdb") do
        network = Tmdb::Network.detail(19)

        network.should be_a(Tmdb::Network)
      end
    end
  end

  context "#alternative_names" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        network = Tmdb::Network.detail(19)
        alternative_names = network.alternative_names

        alternative_names.should be_a(Array(String))
        alternative_names.size.should eq(8)
      end
    end
  end

  context "#images" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        network = Tmdb::Network.detail(19)
        images = network.images

        images.should be_a(Array(Tmdb::Logo))
        images.size.should eq(1)
      end
    end

    it "should get image URL" do
      VCR.use_cassette("tmdb") do
        network = Tmdb::Network.detail(19)
        logo = network.logo_url

        logo.should be_a(String)
      end
    end
  end
end
