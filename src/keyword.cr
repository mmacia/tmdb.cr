require "./filter_factory"

class Tmdb::Keyword
  getter id : Int64
  getter name : String

  def self.detail(id : Int64) : Keyword
    res = Resource.new("/keyword/#{id}")
    Keyword.new(res.get)
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
  end

  # Get the movies that belong to a keyword.
  #
  # We highly recommend using `Tmdb::Dicover.movie` instead of this method as it
  # is much more flexible.
  def movies(language : String? = nil, include_adult : Bool? = nil) : LazyIterator(MovieResult)
    filters = FilterFactory.create_language(language)
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?

    res = Resource.new("/keyword/#{id}/movies", filters)
    LazyIterator(MovieResult).new(res)
  end
end
