require "../profile_urls"

abstract class Tmdb::Tv::CrewBase
  include ProfileUrls

  getter? adult : Bool
  getter gender : Tmdb::Person::Gender?
  getter id : Int64
  getter known_for_department : String?
  getter name : String
  getter original_name : String
  getter popularity : Float64
  getter profile_path : String?
  getter department : String

  def initialize(data : JSON::Any)
    @adult = data["adult"].as_bool
    @gender = data["gender"]? ? Tmdb::Person::Gender.from_value(data["gender"].as_i) : nil
    @id = data["id"].as_i64
    @known_for_department = data["known_for_department"].as_s
    @name = data["name"].as_s
    @original_name = data["original_name"].as_s
    @popularity = data["popularity"].as_f
    @profile_path = data["profile_path"].as_s?
    @department = data["department"].as_s
  end
end
