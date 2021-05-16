require "./spec_helper"

describe Tmdb::Changes do
  context "#movies" do
    start_date = Time.utc(2013, 5, 20, 10, 0, 0)
    end_date = Time.utc(2013, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie

        changes.total_items.should eq(1)
      end
    end

    it "should iterate over all list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie

        changes.each do |change|
          change.should be_a(Tmdb::Changes::Change)
        end
      end
    end

    it "should filter by start date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(start_date: start_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(10337)
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(9793)
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(start_date: start_date, end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(4495)
      end
    end
  end

  context "#tv_show" do
    start_date = Time.utc(2018, 5, 20, 10, 0, 0)
    end_date = Time.utc(2018, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show

        changes.total_items.should eq(1)
      end
    end

    it "should iterate over all list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show

        changes.each do |change|
          change.should be_a(Tmdb::Changes::Change)
        end
      end
    end

    it "should filter by start date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(start_date: start_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(2519)
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(2676)
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(start_date: start_date, end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(1103)
      end
    end
  end

  context "#person" do
    start_date = Time.utc(2018, 5, 20, 10, 0, 0)
    end_date = Time.utc(2018, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person

        changes.total_items.should eq(1)
      end
    end

    it "should iterate over all list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person

        changes.each do |change|
          change.should be_a(Tmdb::Changes::Change)
        end
      end
    end

    it "should filter by start date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person(start_date: start_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(15233)
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person(end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(14237)
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person(start_date: start_date, end_date: end_date)
        n = 0

        changes.total_items.should eq(1)

        changes.each do |change|
          n += 1
          change.should be_a(Tmdb::Changes::Change)
        end

        n.should eq(6018)
      end
    end
  end
end
