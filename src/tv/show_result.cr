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

    begin
      pop = data["popularity"]? ? data["popularity"].as_f : 0.0
    rescue TypeCastError
      pop = data["popularity"].as_i64.to_f64
    end

    @popularity = pop

    @id = data["id"].as_i64
    @overview = data["overview"].as_s
    @backdrop_path = data["backdrop_path"]? ? data["backdrop_path"].as_s? : nil

    begin
      vote_avg = data["vote_average"].as_f
    rescue TypeCastError
      vote_avg = data["vote_average"].as_i64.to_f64
    end

    @vote_average = vote_avg

    date = data["first_air_date"]? ? data["first_air_date"].as_s : ""
    @first_air_date = date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @origin_country = data["origin_country"].as_a.map(&.to_s)
    @genre_ids = data["genre_ids"].as_a.map(&.as_i)
    @original_language = data["original_language"].as_s
    @vote_count = data["vote_count"].as_i
    @name = data["name"].as_s
    @original_name = data["original_name"].as_s
  end

  def tv_show_detail : Show
    Show.detail(id)
  end
end
