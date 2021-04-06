class Tmdb::AlternativeTitle
  getter type : String
  getter title : String
  getter iso_3166_1 : String

  def initialize(data : JSON::Any)
    @type = data["type"].as_s
    @title = data["title"].as_s
    @iso_3166_1 = data["iso_3166_1"].as_s
  end
end
