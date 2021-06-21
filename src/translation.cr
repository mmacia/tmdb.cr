class Tmdb::Translation
  getter iso_3166_1 : String
  getter iso_639_1 : String
  getter name : String?
  getter english_name : String?
  getter title : String?
  getter overview : String?
  getter homepage : String?
  getter runtime : Int32?
  getter tagline : String?
  getter biography : String?

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s
    @iso_639_1 = data["iso_639_1"].as_s
    @name = data["name"].as_s?
    @english_name = data["english_name"].as_s?
    @title = data["data"]["title"]? ? data["data"]["title"].as_s? : nil
    @overview = data["data"]["overview"]? ? data["data"]["overview"].as_s : nil
    @homepage = data["data"]["homepage"]? ? data["data"]["homepage"].as_s : nil
    @runtime = data["data"]["runtime"]? ? data["data"]["runtime"].as_i? : nil
    @tagline = data["data"]["tagline"]? ? data["data"]["tagline"].as_s : nil
    @biography = data["data"]["biography"]? ? data["data"]["biography"].as_s : nil
  end
end
