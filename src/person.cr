require "./filter_factory"

class Tmdb::Person
  enum Gender
    NotSpecified
    Female
    Male
    NonBinary
  end

  class Change
    class Item
      getter id : String
      getter action : String
      getter time : Time
      getter value : String
      getter original_value : String?

      def initialize(data : JSON::Any)
        @id = data["id"].as_s
        @action = data["action"].as_s
        @time = Time.parse(data["time"].as_s, "%Y-%m-%d %H:%M:%s", Time::Location::UTC)
        @value = data["value"].to_json

        if data["original_value"]?
          @original_value = data["original_value"].to_json
        else
          @original_value = nil
        end
      end
    end

    getter key : String
    getter items : Array(Item)

    def initialize(data : JSON::Any)
      @key = data["key"].as_s
      @items = data["items"].as_a.map { |item| Item.new(item) }
    end
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

  # Get the primary person details by id.
  def self.detail(id : Int64, language : String? = nil) : Person
    res = Resource.new("/person/#{id}", FilterFactory.create_language(language))
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
    @birthday = Tmdb.parse_date(data["birthday"])
    @deathday = Tmdb.parse_date(data["deathday"])
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
