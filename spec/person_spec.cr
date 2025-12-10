require "./spec_helper"

describe Tmdb::Person do
  context "#detail" do
    it "should get from ID" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(id: 2712)

        person.should be_a(Tmdb::Person)
      end
    end

    it "should get from ID and language" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(id: 2712, language: "es")

        person.should be_a(Tmdb::Person)
      end
    end
  end

  context "#changes" do
    it "should get a list" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(2712)
        changes = person.changes(Time.utc(2016, 5, 20))

        changes.size.should eq(0)
        changes.should be_a(Array(Tmdb::Change))
      end
    end
  end

  context "#movie_credits" do
    it "should return a list of credits" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.movie_credits

        credits.size.should be > 1
        credits.should be_a(Array(Tmdb::Person::Cast | Tmdb::Person::Crew))
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.movie_credits
        skip_at = 100

        credits.each do |credit|
          skip_at -= 1
          credit.should be_a(Tmdb::Person::Cast | Tmdb::Person::Crew)

          break if skip_at < 0
        end
      end
    end
  end

  context "#tv_credits" do
    it "should return a list of credits" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.tv_credits

        credits.size.should be > 1
        credits.should be_a(Array(Tmdb::Person::Cast | Tmdb::Person::Crew))
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.tv_credits
        skip_at = 100

        credits.each do |credit|
          skip_at -= 1
          credit.should be_a(Tmdb::Person::Cast | Tmdb::Person::Crew)

          break if skip_at < 0
        end
      end
    end
  end

  context "#combined_credits" do
    it "should return a list of credits" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.combined_credits

        credits.size.should be > 1
        credits.should be_a(Array(Tmdb::Person::Cast | Tmdb::Person::Crew))
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.detail(2712)
        credits = person.combined_credits
        skip_at = 100

        credits.each do |credit|
          skip_at -= 1
          credit.should be_a(Tmdb::Person::Cast | Tmdb::Person::Crew)

          break if skip_at < 0
        end
      end
    end
  end

  context "#external_ids" do
    it "should get a list of external IDs" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(2712)
        external_ids = person.external_ids

        external_ids.size.should be > 1
        external_ids.should be_a(Array(Tmdb::ExternalId))
      end
    end
  end

  context "#images" do
    it "should get a list of profile images" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(2712)
        images = person.images

        images.size.should be > 1
        images.should be_a(Array(Tmdb::Profile))
      end
    end
  end

  context "#tagged_images" do
    it "should get a list of tagged images" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(500)
        images = person.tagged_images

        images.total_items.should be > 1
        images.should be_a(Tmdb::LazyIterator(Tmdb::TaggedImage))
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(500)
        images = person.tagged_images
        skip_at = 100

        images.each do |image|
          skip_at -= 1
          image.should be_a(Tmdb::TaggedImage)

          break if skip_at < 0
        end
      end
    end
  end

  context "#translations" do
    it "should get a list of translations" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(500)
        translations = person.translations

        translations.size.should be > 1
        translations.should be_a(Array(Tmdb::Translation))
      end
    end

    it "should iterate over all items" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.detail(500)
        translations = person.translations
        skip_at = 100

        translations.each do |translation|
          skip_at -= 1
          translation.should be_a(Tmdb::Translation)

          break if skip_at < 0
        end
      end
    end
  end

  context "not fully initialized" do
    it "should get adult" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.adult.should be_a(Bool)
      end
    end

    it "should get gender" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.gender.should be_a(Tmdb::Person::Gender)
      end
    end

    it "should get known_for_department" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.known_for_department.should be_a(String)
      end
    end

    it "should get popularity" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.popularity.should be_a(Float64)
      end
    end

    it "should get profile_path" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.profile_path.should be_a(String?)
      end
    end

    it "should get profile URL" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)
        profile = person.profile_url

        profile.should be_a(String)
      end
    end

    it "should get imdb_id" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.imdb_id.should be_a(String)
      end
    end

    it "should get birthday" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.birthday.should be_a(Time?)
      end
    end

    it "should get deathday" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.deathday.should be_a(Time?)
      end
    end

    it "should get place_of_birth" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.place_of_birth.should be_a(String)
      end
    end

    it "should get homepage" do
      VCR.use_cassette("tmdb") do
        person = Tmdb::Person.new(name: "Michael Biehn", id: 2712.to_i64)

        person.homepage.should be_a(String?)
      end
    end
  end

  context "#latest" do
    it "should return a person" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.latest

        person.should be_a(Tmdb::Person)
      end
    end

    it "should return a translated person" do
      VCR.use_cassette "tmdb" do
        person = Tmdb::Person.latest(language: "es")

        person.should be_a(Tmdb::Person)
      end
    end
  end

  context "#popular" do
    it "should return a person list" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Person.popular

        people.should be_a(Tmdb::LazyIterator(Tmdb::PersonResult))
        people.total_items.should be > 1
      end
    end

    it "should return iterate over all items" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Person.popular
        skip_at = 100

        people.each do |person|
          skip_at -= 1
          person.should be_a(Tmdb::PersonResult)

          break if skip_at <= 0
        end
      end
    end

    it "should return a translated person list" do
      VCR.use_cassette "tmdb" do
        people = Tmdb::Person.popular(language: "es")

        people.should be_a(Tmdb::LazyIterator(Tmdb::PersonResult))
        people.total_items.should be > 1
      end
    end
  end
end
