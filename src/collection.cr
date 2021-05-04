require "./movie_result"
require "./image"
require "./translation"
require "./filter_factory"
require "./image_urls"

class Tmdb::Collection
  include ImageUrls

  # Unique ID of the collection
  getter id : Int64
  # Name of the collection
  getter name : String
  # Path to default poster image
  getter poster_path : String
  # Path to default backdrop image
  getter backdrop_path : String
  @overview : String? = nil
  @parts : Array(MovieResult) = [] of MovieResult
  @translations : Array(Translation)? = nil

  private getter? full_initialized : Bool

  # Get collection details by id.
  def self.detail(id : Int64, language : String? = nil) : Collection
    res = Resource.new("/collection/#{id}", FilterFactory.create_language(language))
    Collection.new(res.get)
  end

  def initialize(@id, @name, @poster_path, @backdrop_path)
    @full_initialized = false
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @overview = data["overview"].as_s
    @poster_path = data["poster_path"].as_s
    @backdrop_path = data["backdrop_path"].as_s
    @parts = data["parts"].as_a.map { |part| MovieResult.new(part) }

    @full_initialized = true
  end

  # Array of movies which forms part of the collection
  def parts : Array(MovieResult)
    refresh! unless full_initialized?
    @parts
  end

  # Briefly description of the collection
  def overview : String
    refresh! unless full_initialized?
    @overview.not_nil!
  end

  # Get the images for a collection by id.
  def images(language : String? = nil) : Array(Backdrop | Poster)
    res = Resource.new("/collection/#{id}/images", FilterFactory.create_language(language))
    data = res.get
    ret = [] of Backdrop | Poster

    data["backdrops"].as_a.reduce(ret) { |ret, backdrop| ret << Backdrop.new(backdrop) }
    data["posters"].as_a.reduce(ret) { |ret, poster| ret << Poster.new(poster) }

    ret
  end

  # Get the backdrop images for a collection by id.
  def backdrops(language : String? = nil) : Array(Backdrop)
    images(language).select(Backdrop)
  end

  # Get the poster images for a collection by id.
  def posters(language : String? = nil) : Array(Poster)
    images(language).select(Poster)
  end

  # Get the list translations for a collection by id.
  def translations(language : String? = nil) : Array(Translation)
    Tmdb.memoize :translations do
      res = Resource.new("/collection/#{id}/translations")
      res.get["translations"].as_a.map { |tr| Translation.new(tr) }
    end
  end

  private def refresh!
    obj = Collection.detail(id)

    @id = obj.id
    @name = obj.name
    @overview = obj.overview
    @poster_path = obj.poster_path
    @backdrop_path = obj.backdrop_path
    @parts = obj.parts

    @full_initialized = true
  end
end
