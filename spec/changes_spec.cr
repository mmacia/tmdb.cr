require "./spec_helper"

describe Tmdb::Changes do
  context "#movies" do
    start_date = Time.utc(2013, 5, 20, 10, 0, 0)
    end_date = Time.utc(2013, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie

        changes.total_items.should be > 1
      end
    end

    it "should iterate over all list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie
        skip_at = 100

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end

    it "should filter by start date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(start_date: start_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.movie(start_date: start_date, end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end
  end

  context "#tv_show" do
    start_date = Time.utc(2018, 5, 20, 10, 0, 0)
    end_date = Time.utc(2018, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show

        changes.total_items.should be > 1
      end
    end

    it "should iterate over the list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show
        skip_at = 100

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end

    it "should filter by start date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(start_date: start_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at <= 0
        end
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at < 0
        end
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.tv_show(start_date: start_date, end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at < 0
        end
      end
    end
  end

  context "#person" do
    start_date = Time.utc(2018, 5, 20, 10, 0, 0)
    end_date = Time.utc(2018, 5, 25, 10, 0, 0)

    it "should get a list" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person

        changes.total_items.should be > 1
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
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at < 0
        end
      end
    end

    it "should filter by end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person(end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at < 0
        end
      end
    end

    it "should filter both by start and end date" do
      VCR.use_cassette "tmdb" do
        changes = Tmdb::Changes.person(start_date: start_date, end_date: end_date)
        skip_at = 100

        changes.total_items.should be > 1

        changes.each do |change|
          skip_at -= 1
          change.should be_a(Tmdb::Changes::Change)

          break if skip_at < 0
        end
      end
    end
  end
end
