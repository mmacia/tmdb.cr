class Tmdb::Logo
  getter aspect_ratio : Float64
  getter file_path : String
  getter height : Int32
  getter vote_average : Float64
  getter vote_count : Int64
  getter width : Int32
  getter file_type : String

  def initialize(data : JSON::Any)
    @aspect_ratio = data["aspect_ratio"].as_f
    @file_path = data["file_path"].as_s
    @height = data["height"].as_i
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i64
    @width = data["width"].as_i
    @file_type = data["file_type"].as_s
  end
end
