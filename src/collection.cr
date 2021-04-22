require "./movie_result"
require "./image"
require "./translation"
require "./filter_factory"

class Tmdb::Collection
  getter id : Int64
  getter name : String
  getter poster_path : String
  getter backdrop_path : String
  @overview : String? = nil
  @parts : Array(MovieResult) = [] of MovieResult
  @translations : Array(Translation)? = nil

  private getter? full_initialized : Bool

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

  def parts : Array(MovieResult)
    refresh! unless full_initialized?
    @parts
  end

  def overview : String
    refresh! unless full_initialized?
    @overview.not_nil!
  end

  def backdrops(language : String? = nil) : Array(Image)
    res = Resource.new("/collection/#{id}/images", FilterFactory.create_language(language))
    data = res.get

    data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
  end

  def posters(language : String? = nil) : Array(Image)
    res = Resource.new("/collection/#{id}/images", FilterFactory.create_language(language))
    data = res.get

    data["posters"].as_a.map { |poster| Image.new(poster) }
  end

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
