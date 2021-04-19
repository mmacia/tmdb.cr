require "./episode"
require "./network"
require "./tv_season"

class Tmdb::TVShow
  enum Type
    News
    Scripted
    Documentary
    TalkShow
    Reality
    Miniseries
    Video
  end

  enum Status
    InProduction
    Pilot
    Canceled
    Ended
    ReturningSeries
  end

  getter backdrop_path : String?
  getter created_by : Array(Credit)
  getter episode_run_time : Array(Int32)
  getter first_air_date : Time?
  getter genres : Array(Genre)
  getter homepage : String
  getter id : Int64
  getter? in_production : Bool
  getter languages : Array(String)
  getter last_air_date : Time?
  getter last_episode_to_air : Episode?
  getter name : String
  getter next_episode_to_air : Int32?
  getter networks : Array(Network)
  getter number_of_episodes : Int32?
  getter number_of_seasons : Int32
  getter origin_country : Array(String)
  getter original_language : String
  getter original_name : String
  getter overview : String
  getter popularity : Float64
  getter poster_path : String?
  getter production_companies : Array(CompanyResult)
  getter production_countries : Array(Country)
  getter seasons : Array(TVSeason)
  getter spoken_languages : Array(Language)
  getter status : Status
  getter tagline : String
  getter type : Type
  getter vote_average : Float64
  getter vote_count : Int32

  def self.detail(id : Int64, language : String? = nil) : TVShow
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}", filters)
    TVShow.new(res.get)
  end

  def initialize(data : JSON::Any)
    @backdrop_path = data["backdrop_path"].as_s?

    @created_by = data["created_by"].as_a.map do |credit|
      Credit.detail(credit["credit_id"].as_s)
    end

    @episode_run_time = data["episode_run_time"].as_a.map(&.as_i)

    date = data["first_air_date"].as_s?
    @first_air_date = date.nil? || date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @genres = data["genres"].as_a.map do |genre|
      Genre.new(genre)
    end

    @homepage = data["homepage"].as_s
    @id = data["id"].as_i64
    @in_production = data["in_production"].as_bool
    @languages = data["languages"].as_a.map(&.as_s)

    date = data["last_air_date"].as_s?
    @last_air_date = date.nil? || date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @last_episode_to_air = Episode.new(data["last_episode_to_air"]) unless data["last_episode_to_air"]?
    @name = data["name"].as_s
    @next_episode_to_air = data["next_episode_to_air"].as_i?

    @networks = data["networks"].as_a.map do |network|
      Network.new(network)
    end

    @number_of_episodes = data["number_of_episodes"].as_i?
    @number_of_seasons = data["number_of_seasons"].as_i
    @origin_country = data["origin_country"].as_a.map(&.as_s)
    @original_language = data["original_language"].as_s
    @original_name = data["original_name"].as_s
    @overview = data["overview"].as_s
    @popularity = data["popularity"].as_f
    @poster_path = data["poster_path"].as_s?
    @production_companies = data["production_companies"].as_a.map { |company| CompanyResult.new(company) }
    @production_countries = data["production_countries"].as_a.map { |country| Country.new(country) }
    @seasons = data["seasons"].as_a.map { |season| TVSeason.new(season) }
    @spoken_languages = data["spoken_languages"].as_a.map { |lang| Language.new(lang) }
    @status = Status.parse(data["status"].as_s.gsub(" ", ""))
    @tagline = data["tagline"].as_s
    @type = Type.parse(data["type"].as_s.gsub(" ", ""))
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end
end
