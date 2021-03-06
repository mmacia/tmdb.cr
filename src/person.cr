require "./filter_factory"
require "./profile_urls"
require "./person/cast"
require "./person/crew"
require "./external_id"
require "./image"
require "./change"

class Tmdb::Person
  include ProfileUrls

  enum Gender
    NotSpecified
    Female
    Male
    NonBinary
  end

  getter id : Int64
  getter name : String
  getter also_known_as : Array(String) = [] of String
  @adult : Bool? = nil
  @gender : Gender = Gender::NotSpecified
  @known_for_department : String? = nil
  @popularity : Float64? = nil
  @profile_path : String? = nil
  @biography : String?
  @imdb_id : String? = nil
  @birthday : Time? = nil
  @deathday : Time? = nil
  @place_of_birth : String? = nil
  @homepage : String? = nil

  private getter? full_initialized : Bool

  # Get the primary person details by id.
  def self.detail(id : Int64, language : String? = nil) : Person
    res = Resource.new("/person/#{id}", FilterFactory.create_language(language))
    Person.new(res.get)
  end

  # Get the most newly created person. This is a live response and will
  # continuously change.
  def self.latest(language : String? = nil) : Person
    res = Resource.new("/person/latest", FilterFactory.create_language(language))
    Person.new(res.get)
  end

  # Get the list of popular people on TMDB. This list updates daily.
  def self.popular(language : String? = nil, skip_cache : Bool = false) : LazyIterator(PersonResult)
    res = Resource.new("/person/popular", FilterFactory.create_language(language))
    LazyIterator(PersonResult).new(res, skip_cache: skip_cache)
  end

  def initialize(@adult, gender : Int32, @id, @known_for_department, @name, @popularity, @profile_path)
    @gender = Gender.from_value(gender)
    @full_initialized = false
  end

  def initialize(@name, @id)
    @full_initialized = false
  end

  def initialize(data : JSON::Any)
    @adult = data["adult"].as_bool
    @gender = Gender.from_value(data["gender"].as_i)
    @id = data["id"].as_i64
    @known_for_department = data["known_for_department"].as_s?
    @name = data["name"].as_s
    @popularity = data["popularity"].as_f
    @profile_path = data["profile_path"].as_s?

    biography = data["biography"].as_s
    @biography = biography.empty? ? nil : biography

    imdb_id = data["imdb_id"].as_s?
    @imdb_id = imdb_id == "" ? nil : imdb_id

    @birthday = Tmdb.parse_date(data["birthday"])
    @deathday = Tmdb.parse_date(data["deathday"])
    @place_of_birth = data["place_of_birth"].as_s?
    @homepage = data["homepage"].as_s?

    @full_initialized = true
  end

  def adult : Bool
    refresh! unless full_initialized?
    @adult.not_nil!
  end

  def gender : Gender
    refresh! unless full_initialized?
    @gender
  end

  def known_for_department : String?
    refresh! unless full_initialized?
    @known_for_department
  end

  def popularity : Float64
    refresh! unless full_initialized?
    @popularity.not_nil!
  end

  def profile_path : String?
    refresh! unless full_initialized?
    @profile_path
  end

  def biography : String?
    refresh! unless full_initialized?
    @biography
  end

  def imdb_id : String?
    refresh! unless full_initialized?
    @imdb_id
  end

  def birthday : Time?
    refresh! unless full_initialized?
    @birthday
  end

  def deathday : Time?
    refresh! unless full_initialized?
    @deathday
  end

  def place_of_birth : String?
    refresh! unless full_initialized?
    @place_of_birth
  end

  def homepage : String?
    refresh! unless full_initialized?
    @homepage
  end

  # Get the changes for a movie. By default only the last 24 hours are returned.
  #
  # You can query up to 14 days in a single query by using the `start_date` and
  # `end_date` query parameters.
  def changes(start_date : Time? = nil, end_date : Time? = nil) : Array(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/person/#{id}/changes", filters)
    data = res.get

    data["changes"].as_a.map { |change| Change.new(change) }
  end

  # Get the movie credits for a person.
  def movie_credits(language : String? = nil) : Array(Person::Cast | Person::Crew)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/movie_credits", filters)
    data = res.get
    ret = [] of Person::Cast | Person::Crew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Person::Cast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Person::Crew.new(crew) }

    ret
  end

  # Get the TV show credits for a person.
  # You can query for some extra details about the credit with the credit method.
  def tv_credits(language : String? = nil) : Array(Person::Cast | Person::Crew)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/tv_credits", filters)
    data = res.get
    ret = [] of Person::Cast | Person::Crew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Person::Cast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Person::Crew.new(crew) }

    ret
  end

  # Get the movie and TV credits together in a single response.
  def combined_credits(language : String? = nil) : Array(Person::Cast | Person::Crew)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/combined_credits", filters)
    data = res.get
    ret = [] of Person::Cast | Person::Crew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Person::Cast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Person::Crew.new(crew) }

    ret
  end

  # Get the external ids for a person. We currently support the following external
  # sources.
  #
  # IMDb ID
  # Facebook
  # Freebase MID
  # Freebase ID
  # Instagram
  # TVRage ID
  # Twitter
  def external_ids(language : String? = nil) : Array(ExternalId)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/external_ids", filters)
    data = res.get
    ret = [] of ExternalId

    %w(imdb_id facebook_id freebase_mid freebase_id tvrage_id instagram_id twitter_id).each do |provider|
      ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
    end

    ret
  end

  # Get the images for a person.
  def images : Array(Profile)
    res = Resource.new("/person/#{id}/images")
    data = res.get

    data["profiles"].as_a.map { |profile| Profile.new(profile) }
  end

  # See `images`
  def profiles : Array(Profile)
    images
  end

  # Get the images that this person has been tagged in.
  def tagged_images(language : String? = nil) : LazyIterator(TaggedImage)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/tagged_images", filters)
    LazyIterator(TaggedImage).new(res)
  end

  # Get a list of translations that have been created for a person.
  def translations(language : String? = nil) : Array(Translation)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/person/#{id}/translations", filters)
    data = res.get
    data["translations"].as_a.map { |tr| Translation.new(tr) }
  end

  private def refresh!
    obj = Person.detail(id)

    @adult = obj.adult
    @gender = obj.gender
    @id = obj.id
    @known_for_department = obj.known_for_department
    @name = obj.name
    @popularity = obj.popularity
    @profile_path = obj.profile_path
    @biography = obj.biography
    @imdb_id = obj.imdb_id
    @birthday = obj.birthday
    @deathday = obj.deathday
    @place_of_birth = obj.place_of_birth
    @homepage = obj.homepage

    @full_initialized = true
  end
end
