require "./spec_helper"

describe Tmdb::Company do
  it "should get a list of alternative names" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      alternative_names = company.alternative_names

      alternative_names.size.should eq(0)
      alternative_names.should be_a(Array(String))
    end
  end

  it "should get a list of logos" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      logos = company.logos

      logos.size.should eq(1)
      logos.should be_a(Array(Tmdb::Logo))
    end
  end

  it "should get image URL" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      logo_url = company.logo_url

      logo_url.should be_a(String)
    end
  end

  it "should get the description" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      description = company.description

      description.should be_a(String)
    end
  end

  it "should get the headquarters" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      hq = company.headquarters

      hq.should be_a(String)
    end
  end

  it "should get the homepage" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      homepage = company.homepage

      homepage.should be_a(String)
    end
  end

  it "should get the parent company" do
    VCR.use_cassette("tmdb") do
      company = Tmdb::Company.detail(99272)
      parent = company.parent_company

      parent.should be_a(Tmdb::Company?)
    end
  end
end
