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

  def initialize(data : JSON::Any)
    @author = Author.new(data["author_details"])
    @content = data["content"].as_s
    @created_at = Time.parse_rfc3339(data["created_at"].as_s)
    @id = data["id"].as_s
    @updated_at = Time.parse_rfc3339(data["updated_at"].as_s)
    @url = data["url"].as_s
  end
end
