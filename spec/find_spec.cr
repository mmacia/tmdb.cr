require "./spec_helper"

describe Tmdb::Find do
  person_id = "nm0000706"  # Michelle Yeoh
  movie_id = "tt0113243"  # Hackers
  tv_show_id = "tt5171438"  # star trek discovery

  context "#find" do
    it "should get a list" do
      VCR.use_cassette "tmdb" do
        found = Tmdb::Find.find(person_id, Tmdb::Find::ExternalSource::Imdb)

        found.size.should eq(1)
      end
    end
  end

  context "#find_movies" do
    it "should get a list" do
      VCR.use_cassette "tmdb" do
        found = Tmdb::Find.find_movie(movie_id, Tmdb::Find::ExternalSource::Imdb)

        found.size.should eq(1)
      end
    end
  end

  context "#find_tv_shows" do
    it "should get a list" do
      VCR.use_cassette "tmdb" do
        found = Tmdb::Find.find_tv_show(tv_show_id, Tmdb::Find::ExternalSource::Imdb)

        found.size.should eq(1)
      end
    end
  end

  context "#find_people" do
    it "should get a list" do
      VCR.use_cassette "tmdb" do
        found = Tmdb::Find.find_person(person_id, Tmdb::Find::ExternalSource::Imdb)

        found.size.should eq(1)
      end
    end
  end
end
