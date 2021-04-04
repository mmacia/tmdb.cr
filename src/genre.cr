class Tmdb::Genre
  getter id : Int64
  getter name : String

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
  end
end
