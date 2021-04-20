class Tmdb::Tv::Season
  getter air_date : Time?
  getter poster_path : String?
  getter season_number : Int32
  getter id : Int64
  getter name : String
  getter overview : String

  def initialize(data : JSON::Any)
    date = data["air_date"].as_s?
    @air_date = date.nil? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @poster_path = data["poster_path"].as_s?
    @season_number = data["season_number"].as_i
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @overview = data["overview"].as_s
  end
end
