class Tmdb::Video
  enum Type
    Trailer
    Teaser
    Clip
    Featurette
    BehindTheScenes
    Bloopers
  end

  getter id : String
  getter iso_639_1 : String
  getter iso_3166_1 : String
  getter key : String
  getter name : String
  getter site : String
  getter size : Int32
  getter type : Type

  def initialize(data : JSON::Any)
    @id = data["id"].as_s
    @iso_639_1 = data["iso_639_1"].as_s
    @iso_3166_1 = data["iso_3166_1"].as_s
    @key = data["key"].as_s
    @name = data["name"].as_s
    @site = data["site"].as_s
    @size = data["size"].as_i
    @type = Type.parse(data["type"].as_s)
  end
end
