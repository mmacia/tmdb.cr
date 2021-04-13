class Tmdb::Person
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
  @known_for_department : String = ""
  @popularity : Float64? = nil
  @profile_path : String? = nil
  @biography : String = ""
  @imdb_id : String = ""
  @birthday : Time? = nil
  @deathday : Time? = nil
  @place_of_birth : String? = nil
  @homepage : String? = nil

  private getter? full_initialized : Bool

  def self.detail(id : Int64, language : String? = nil) : Person
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/person/#{id}", filters)
    Person.new(res.get)
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
    @known_for_department = data["known_for_department"].as_s
    @name = data["name"].as_s
    @popularity = data["popularity"].as_f
    @profile_path = data["profile_path"].as_s?
    @biography = data["biography"].as_s
    @imdb_id = data["imdb_id"].as_s

    date = data["birthday"].as_s
    @birthday = date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    date = data["deathday"].as_s?
    @deathday = (date.nil? || date.not_nil!.empty?) ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)
    @place_of_birth = data["place_of_birth"].as_s
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

  def known_for_department : String
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

  def biography : String
    refresh! unless full_initialized?
    @biography
  end

  def imdb_id : String
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

  def place_of_birth : String
    refresh! unless full_initialized?
    @place_of_birth.not_nil!
  end

  def homepage : String?
    refresh! unless full_initialized?
    @homepage
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
