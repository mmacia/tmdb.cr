require "./movie"
require "./image_urls"

class Tmdb::MovieResult
  include ImageUrls

  getter poster_path : String?
  getter? adult : Bool
  getter overview : String
  getter release_date : Time?
  getter genre_ids : Array(Int32)
  getter id : Int64
  getter original_title : String
  getter original_language : String
  getter title : String
  getter backdrop_path : String?
  getter popularity : Float64
  getter vote_count : Int32
  getter? video : Bool
  getter vote_average : Float64

  def initialize(data : JSON::Any)
    @poster_path = data["poster_path"]? ? data["poster_path"].as_s? : nil
    @adult = data["adult"].as_bool
    @overview = data["overview"].as_s

    date = data["release_date"]? ?  data["release_date"].as_s : ""
    @release_date = date.empty? ? nil : Time.parse(date,"%Y-%m-%d", Time::Location::UTC)

    begin
      genre_ids = data["genre_ids"].as_a.map { |genre| Tmdb.resilient_parse_int32(genre) }
    rescue TypeCastError
      genre_ids = [] of Int32
    end

    @genre_ids = genre_ids || [] of Int32

    @id = Tmdb.resilient_parse_int64(data["id"])
    @original_title = data["original_title"].as_s
    @original_language = data["original_language"].as_s
    @title = data["title"].as_s
    @backdrop_path = data["backdrop_path"]? ? data["backdrop_path"].as_s? : nil
    @popularity = data["popularity"]? ? Tmdb.resilient_parse_float64(data["popularity"]) : 0.0
    @vote_count = Tmdb.resilient_parse_int32(data["vote_count"])
    @video = data["video"].as_bool
    @vote_average = Tmdb.resilient_parse_float64(data["vote_average"])
  end

  def movie_detail(language : String? = nil) : Movie
    res = Resource.new("/movie/#{id}")
    Movie.detail(id, language)
  end
end
