require "../spec_helper"

describe Tmdb::Tv::EpisodeGroup do
  context "#detail" do
    it "should get an episode group instance" do
      VCR.use_cassette("tmdb") do
        episode_group = Tmdb::Tv::EpisodeGroup.detail("5f178369a6d93100377f6087")

        episode_group.should be_a(Tmdb::Tv::EpisodeGroup)
      end
    end

    it "should get an translated episode group instance" do
      VCR.use_cassette("tmdb") do
        episode_group = Tmdb::Tv::EpisodeGroup.detail("5f178369a6d93100377f6087", language: "es")

        episode_group.should be_a(Tmdb::Tv::EpisodeGroup)
      end
    end
  end
end
