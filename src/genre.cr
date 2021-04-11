class Tmdb::Genre
  getter id : Int64
  getter name : String

  def self.movie_list(language : String? = nil) : Array(Genre)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/genre/movie/list", filters)
    data = res.get

    data["genres"].as_a.map { |g| Genre.new(g) }
  end

  def self.tv_list(language : String? = nil) : Array(Genre)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/genre/tv/list", filters)
    data = res.get

    data["genres"].as_a.map { |g| Genre.new(g) }
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
  end
end
