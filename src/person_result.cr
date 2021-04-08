require "./tv_show_result"
require "./movie_result"

class Tmdb::PersonResult
  getter profile_path : String?
  getter adult : Bool
  getter id : Int64
  getter name : String
  getter popularity : Float64
  getter known_for : Array(MovieResult | TVShowResult)

  def initialize(data : JSON::Any)
    @profile_path = data["profile_path"].as_s?
    @adult = data["adult"].as_bool
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @popularity = data["popularity"].as_f

    @known_for = data["known_for"].as_a.map do |item|
      if item["media_type"].as_s == "tv"
        TVShowResult.new(item)
      else
        MovieResult.new(item)
      end
    end
  end

  def person_detail : Person
    Person.detail(id)
  end
end
