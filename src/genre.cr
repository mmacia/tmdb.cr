class Tmdb::Genre
  getter id : Int64
  getter name : String

  def self.movie_list(language : String? = nil) : Array(Genre)
    res = Resource.new("/genre/movie/list", FilterFactory.create_language(language))
    res.get["genres"].as_a.map { |g| Genre.new(g) }
  end

  def self.tv_list(language : String? = nil) : Array(Genre)
    res = Resource.new("/genre/tv/list", FilterFactory.create_language(language))
    res.get["genres"].as_a.map { |g| Genre.new(g) }
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
  end
end
