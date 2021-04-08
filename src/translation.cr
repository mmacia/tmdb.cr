class Tmdb::Translation
  getter iso_3166_1 : String
  getter iso_639_1 : String
  getter name : String
  getter english_name : String
  getter title : String
  getter overview : String
  getter homepage : String
  getter runtime : Int32?
  getter tagline : String

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s
    @iso_639_1 = data["iso_639_1"].as_s
    @name = data["name"].as_s
    @english_name = data["english_name"].as_s
    @title = data["data"]["title"].as_s
    @overview = data["data"]["overview"].as_s
    @homepage = data["data"]["homepage"].as_s
    @runtime = data["data"]["runtime"]? ? data["data"]["runtime"].as_i? : nil
    @tagline = data["data"]["tagline"]? ? data["data"]["tagline"].as_s : ""
  end
end
