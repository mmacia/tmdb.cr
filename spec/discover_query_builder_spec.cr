require "./spec_helper"

describe Tmdb::Discover::QueryBuilder do

  it "should return what movies are in theatres" do
    qb = Tmdb::Discover::QueryBuilder.new
      .primary_release_date_gte(Time.utc(2014, 9, 15))
      .primary_release_date_lte(Time.utc(2014, 10, 22))

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("primary_release_date.gte=2014-09-15&primary_release_date.lte=2014-10-22")
  end

  it "should return what movies are the most popular movies" do
    qb = Tmdb::Discover::QueryBuilder.new
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::PopularityDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=popularity.desc")
  end

  it "should return what movies are the highest rated movies rated R" do
    qb = Tmdb::Discover::QueryBuilder.new
      .certification_country("us")
      .certification("R")
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::VoteAverageDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=vote_average.desc&certification_country=US&certification=R")
  end

  it "should return what movies are the most popular kids movies" do
    qb = Tmdb::Discover::QueryBuilder.new
      .certification_country("us")
      .certification_lte("G")
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::PopularityDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=popularity.desc&certification_country=US&certification.lte=G")
  end

  it "should return what movies are the best movies from 2010" do
    qb = Tmdb::Discover::QueryBuilder.new
      .primary_release_year(2010)
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::VoteAverageDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=vote_average.desc&primary_release_year=2010")
  end

  it "should return what movies are the best dramas that were released this year" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_genres(18)
      .primary_release_year(2014)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("primary_release_year=2014&with_genres=18")
  end

  it "should return what movies are the highest rated science fiction movies that Tom Cruise has been in" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_genres(878)
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::VoteAverageDesc)
      .with_cast(500)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=vote_average.desc&with_cast=500&with_genres=878")
  end

  it "should return what movies are the Will Ferrell's highest grossing comedies" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_genres(35)
      .with_cast(23659)
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::RevenueDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=revenue.desc&with_cast=23659&with_genres=35")
  end

  it "should return if have Brad Pitt and Edward Norton ever been in a movie together" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_people([287.to_i64, 819.to_i64])
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::VoteAverageDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=vote_average.desc&with_people=287%2C819")
  end

  it "should return if has David Fincher ever worked with Rooney Mara" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_people([108_916.to_i64, 7_467.to_i64])
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::PopularityDesc)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=popularity.desc&with_people=108916%2C7467")
  end

  it "should return what are the best dramas" do
    qb = Tmdb::Discover::QueryBuilder.new
      .with_genres(18)
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::VoteAverageDesc)
      .vote_count_gte(10)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=vote_average.desc&vote_count.gte=10&with_genres=18")
  end

  it "should return what are Liam Neeson's highest grossing rated R movies" do
    qb = Tmdb::Discover::QueryBuilder.new
      .certification_country("us")
      .certification("R")
      .sort_by(Tmdb::Discover::QueryBuilder::SortType::RevenueDesc)
      .with_cast(3896)

    subject = Tmdb.api.make_query_params(qb.to_filter)
    subject.should eq("sort_by=revenue.desc&certification_country=US&certification=R&with_cast=3896")
  end
end
