require "../image_urls"
require "../credit"

class Tmdb::Person
  class CreditBase
    include ImageUrls

    getter id : Int64
    getter credit_id : String
    getter original_language : String
    getter original_title : String?
    getter overview : String
    getter vote_average : Float64
    getter vote_count : Int32
    getter? video : Bool?
    getter? adult : Bool?
    getter backdrop_path : String?
    getter poster_path : String?
    getter genre_ids : Array(Int32)
    getter popularity : Float64
    getter release_date : Time?
    getter title : String?

    def initialize(data : JSON::Any)
      @id = data["id"].as_i64
      @credit_id = data["credit_id"].as_s
      @original_language = data["original_language"].as_s
      @original_title = data["original_title"]? ? data["original_title"].as_s : nil
      @overview = data["overview"].as_s
      @vote_average = data["vote_average"].as_f
      @vote_count = data["vote_count"].as_i
      @video = data["video"]? ? data["video"].as_bool : nil
      @adult = data["adult"]? ? data["adult"].as_bool : nil
      @backdrop_path = data["backdrop_path"].as_s?
      @poster_path = data["poster_path"].as_s?
      @genre_ids = data["genre_ids"].as_a.map(&.as_i)
      @popularity = data["popularity"].as_f
      @release_date = data["release_date"]? ? Time.parse(data["release_date"].as_s, "%Y-%m-%d", Time::Location::UTC) : nil
      @title = data["title"]? ? data["title"].as_s : nil
    end

    def detail : Credit
      Credit.detail(credit_id)
    end
  end
end
