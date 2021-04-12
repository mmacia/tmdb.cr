require "./spec_helper"

describe Tmdb::Certification do
  it "should get a list of movie certifications" do
    VCR.use_cassette("tmdb") do
      certs = Tmdb::Certification.movies

      certs.size.should eq(24)
      certs.should be_a(Hash(String, Array(Tmdb::Certification)))
    end
  end

  it "should get a list of tv show certifications" do
    VCR.use_cassette("tmdb") do
      certs = Tmdb::Certification.tv_shows

      certs.size.should eq(18)
      certs.should be_a(Hash(String, Array(Tmdb::Certification)))
    end
  end
end
