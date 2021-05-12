require "./tv/show_result"
require "./movie_result"
require "./profile_urls"

class Tmdb::PersonResult
  include ProfileUrls

  getter profile_path : String?
  getter adult : Bool
  getter id : Int64
  getter name : String
  getter popularity : Float64
  getter known_for : Array(MovieResult | Tv::ShowResult)

  def initialize(data : JSON::Any)
    @profile_path = data["profile_path"].as_s?
    @adult = data["adult"].as_bool
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @popularity = data["popularity"]? ? Tmdb.resilient_parse_float64(data["popularity"]) : 0.0

    begin
      known_for = data["known_for"].as_a.map do |item|
        if item["media_type"].as_s == "tv"
          Tv::ShowResult.new(item)
        else
          MovieResult.new(item)
        end
      end
    rescue TypeCastError
      known_for = [] of MovieResult | Tv::ShowResult
    end

    @known_for = known_for || [] of MovieResult | Tv::ShowResult
  end

  def person_detail : Person
    Person.detail(id)
  end
end
