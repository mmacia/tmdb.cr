require "./collection"
require "./image_urls"

class Tmdb::CollectionResult
  include ImageUrls

  getter id : Int64
  getter backdrop_path : String?
  getter poster_path : String?
  getter name : String

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @backdrop_path = data["backdrop_path"].as_s?
    @poster_path = data["poster_path"].as_s?
    @name = data["name"].as_s
  end

  def collection_detail : Collection
    Collection.detail(id)
  end
end
