require "./media_type"

class Tmdb::Review
  class Author
    getter name : String
    getter username : String
    getter avatar_path : String?
    getter rating : Float64?

    def initialize(data : JSON::Any)
      @name = data["name"].as_s
      @username = data["username"].as_s
      @avatar_path = data["avatar_path"].as_s?
      @rating = data["rating"].as_f?
    end
  end

  getter author : Author
  getter content : String
  getter created_at : Time
  getter id : String
  getter updated_at : Time
  getter url : String
  getter iso_639_1 : String? = nil
  getter media_id : Int64? = nil
  getter media_title : String? = nil
  getter media_type : Media::Type? = nil

  def self.detail(id : String) : Review
    res = Resource.new("/review/#{id}")
    Review.new(res.get)
  end

  def initialize(data : JSON::Any)
    @author = Author.new(data["author_details"])
    @content = data["content"].as_s
    @created_at = Time.parse_rfc3339(data["created_at"].as_s)
    @id = data["id"].as_s
    @updated_at = Time.parse_rfc3339(data["updated_at"].as_s)
    @url = data["url"].as_s

    @media_id = data["media_id"].as_i64 if data["media_id"]?
    @media_title = data["media_title"].as_s if data["media_title"]?
    @media_type = Media::Type.parse(data["media_type"].as_s) if data["media_type"]?
  end
end
