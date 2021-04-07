class Tmdb::Person
  enum Gender
    NotSpecified
    Female
    Male
    NonBinary
  end

  getter adult : Bool
  getter gender : Gender = Gender::NotSpecified
  getter id : Int64
  getter known_for_department : String
  getter name : String
  getter also_known_as : Array(String) = [] of String
  getter popularity : Float64
  getter profile_path : String?
  @biography : String = ""
  @imdb_id : String = ""
  @birthday : Time? = nil
  @deathday : Time? = nil
  @place_of_birth : String? = nil
  @homepage : String? = nil

  private getter? full_initialized : Bool

  def initialize(data : JSON::Any, @full_initialized)
    @adult = data["adult"].as_bool
    @gender = Gender.from_value(data["gender"].as_i)
    @id = data["id"].as_i64
    @known_for_department = data["known_for_department"].as_s
    @name = data["name"].as_s
    @popularity = data["popularity"].as_f
    @profile_path = data["profile_path"].as_s?
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
    @place_of_birth
  end

  def homepage : String?
    refresh! unless full_initialized?
    @homepage
  end

  private def refresh!
    res = Resource.new("/person/#{id}")
    data = res.get

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
end
