require "./collection"
require "./genre"
require "./company"

class Tmdb::Movie
  enum Status
    Rumored
    Planned
    InProduction
    PostProduction
    Released
    Canceled
  end

  getter? adult : Bool
  getter backdrop_path : String?
  getter belongs_to_collection : Collection?
  getter budget : Int64
  getter genres : Array(Genre)
  getter homepage : String?
  getter id : Int64
  getter imdb_id : String?
  getter original_language : String
  getter original_title : String
  getter overview : String?
  getter popularity : Float64
  getter poster_path : String?
  getter production_companies : Array(Company)
  #getter production_countries : Array(Country)
  getter release_date : Time?
  getter revenue : Int32
  getter runtime : Int32?
  #getter spoken_languages : Array(Language)
  getter status : Status
  getter tagline : String?
  getter title : String
  getter? video : Bool
  getter vote_average : Float64
  getter vote_count : Int32

  def initialize(data : JSON::Any)
    @adult = data["adult"].as_bool
    @backdrop_path = data["backdrop_path"].as_s?

    btc = data["belongs_to_collection"]
    @belongs_to_collection = Collection.new(
      id: btc["id"].as_i64,
      name: btc["name"].as_s,
      poster_path: btc["poster_path"].as_s,
      backdrop_path: btc["backdrop_path"].as_s
    )

    @budget = data["budget"].as_i64

    @genres = data["genres"].as_a.map do |genre|
      Genre.new(genre)
    end

    @homepage = data["homepage"].as_s?
    @id = data["id"].as_i64
    @imdb_id = data["imdb_id"].as_s?
    @original_language = data["original_language"].as_s
    @original_title = data["original_title"].as_s
    @overview = data["overview"].as_s?
    @popularity = data["popularity"].as_f
    @poster_path = data["poster_path"].as_s?

    @production_companies = data["production_companies"].as_a.map do |company|
      Company.new(
        id: company["id"].as_i64,
        name: company["name"].as_s,
        logo_path: company["logo_path"].as_s?,
        origin_country: company["origin_country"].as_s
      )
    end

    #@production_countries = data["production_countries"]

    date = data["release_date"].as_s
    @release_date = date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @revenue = data["revenue"].as_i
    @runtime = data["runtime"].as_i
    #@spoken_languages = data["spoken_languages"]
    @status = Status.parse(data["status"].as_s)
    @tagline = data["tagline"].as_s?
    @title = data["title"].as_s
    @video = data["video"].as_bool
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end
end
