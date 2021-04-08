require "./movie_result"
require "./image"
require "./translation"

class Tmdb::Collection
  getter id : Int64
  getter name : String
  getter poster_path : String
  getter backdrop_path : String
  @overview : String? = nil
  @parts : Array(MovieResult) = [] of MovieResult
  @backdrops : Array(Image)? = nil
  @posters : Array(Image)? = nil
  @translations : Array(Translation)? = nil

  private getter? full_initialized : Bool

  def self.detail(id : Int64, language : String? = nil) : Collection
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/collection/#{id}", filters)
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

    @parts = data["parts"].as_a.map do |part|
      MovieResult.new(part)
    end
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
    return @backdrops.not_nil! unless @backdrops.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/collection/#{id}/images", filters)
    data = res.get

    @backdrops = data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
    @posters = data["posters"].as_a.map { |poster| Image.new(poster) }

    @backdrops.not_nil!
  end

  def posters(language : String? = nil) : Array(Image)
    return @posters.not_nil! unless @posters.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/collection/#{id}/images", filters)
    data = res.get

    @backdrops = data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
    @posters = data["posters"].as_a.map { |poster| Image.new(poster) }

    @posters.not_nil!
  end

  def translations(language : String? = nil) : Array(Translation)
    return @translations.not_nil! unless @translations.nil?

    res = Resource.new("/collection/#{id}/translations")
    data = res.get

    @translations = data["translations"].as_a.map { |tr| Translation.new(tr) }
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
