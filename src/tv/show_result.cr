require "./show"
require "../image_urls"

class Tmdb::Tv::ShowResult
  include ImageUrls

  getter poster_path : String?
  getter popularity : Float64
  getter id : Int64
  getter overview : String
  getter backdrop_path : String?
  getter vote_average : Float64
  getter first_air_date : Time?
  getter origin_country : Array(String)
  getter genre_ids : Array(Int32)
  getter original_language : String
  getter vote_count : Int32
  getter name : String
  getter original_name : String

  def initialize(data : JSON::Any)
    @poster_path = data["poster_path"]? ? data["poster_path"].as_s? : nil
    @popularity = data["popularity"]? ? Tmdb.resilient_parse_float64(data["popularity"]) : 0.0
    @id = Tmdb.resilient_parse_int64(data["id"])
    @overview = data["overview"].as_s
    @backdrop_path = data["backdrop_path"]? ? data["backdrop_path"].as_s? : nil
    @vote_average = Tmdb.resilient_parse_float64(data["vote_average"])

    date = data["first_air_date"]? ? data["first_air_date"].as_s : ""
    @first_air_date = date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @origin_country = data["origin_country"].as_a.map(&.to_s)
    @genre_ids = data["genre_ids"].as_a.map { |num| Tmdb.resilient_parse_int32(num) }
    @original_language = data["original_language"].as_s
    @vote_count = Tmdb.resilient_parse_int32(data["vote_count"])
    @name = data["name"].as_s
    @original_name = data["original_name"].as_s
  end

  def tv_show_detail : Show
    Show.detail(id)
  end
end
