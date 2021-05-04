require "./image"

class Tmdb::Logo < Tmdb::Image
  getter file_type : String

  def initialize(data : JSON::Any)
    super(data)
    @file_type = data["file_type"].as_s
  end
end
