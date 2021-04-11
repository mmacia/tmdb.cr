require "./collection"
require "./genre"
require "./company"
require "./country"
require "./language"
require "./alternative_title"
require "./cast_credit"
require "./crew_credit"
require "./image"
require "./release"
require "./review"
require "./translation"
require "./video"
require "./watch"
require "./keyword"

class Tmdb::Movie
  enum Status
    Rumored
    Planned
    InProduction
    PostProduction
    Released
    Canceled
  end

  alias ExternalId = Tuple(String, String)

  getter? adult : Bool
  getter backdrop_path : String?
  getter belongs_to_collection : Collection?
  getter budget : Int64
  getter genres : Array(Genre)
  getter homepage : String?
  getter id : Int64
  getter imdb_id : String?
  getter original_language : String
  getter original_title : String
  getter overview : String?
  getter popularity : Float64
  getter poster_path : String?
  getter production_companies : Array(Company)
  getter production_countries : Array(Country)
  getter release_date : Time?
  getter revenue : Int32
  getter runtime : Int32?
  getter spoken_languages : Array(Language)
  getter status : Status
  getter tagline : String?
  getter title : String
  getter? video : Bool
  getter vote_average : Float64
  getter vote_count : Int32

  @alternative_titles : Array(AlternativeTitle)? = nil
  @cast : Array(CastCredit)? = nil
  @crew : Array(CrewCredit)? = nil
  @external_ids : Array(ExternalId)? = nil
  @backdrops : Array(Image)? = nil
  @posters : Array(Image)? = nil
  @keywords : Array(Keyword)? = nil
  @release_dates : Array(Tuple(String, Array(Release)))? = nil
  @translations : Array(Translation)? = nil
  @videos : Array(Video)? = nil
  @watch_providers : Hash(String, Watch)? = nil

  def self.detail(id : Int64, language : String? = nil) : Movie
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}", filters)
    Movie.new(res.get)
  end

  def initialize(data : JSON::Any)
    @adult = data["adult"].as_bool
    @backdrop_path = data["backdrop_path"].as_s?

    btc = data["belongs_to_collection"]
    @belongs_to_collection = Collection.new(
      id: btc["id"].as_i64,
      name: btc["name"].as_s,
      poster_path: btc["poster_path"].as_s,
      backdrop_path: btc["backdrop_path"].as_s
    )

    @budget = data["budget"].as_i64

    @genres = data["genres"].as_a.map do |genre|
      Genre.new(genre)
    end

    @homepage = data["homepage"].as_s?
    @id = data["id"].as_i64
    @imdb_id = data["imdb_id"].as_s?
    @original_language = data["original_language"].as_s
    @original_title = data["original_title"].as_s
    @overview = data["overview"].as_s?
    @popularity = data["popularity"].as_f
    @poster_path = data["poster_path"].as_s?

    @production_companies = data["production_companies"].as_a.map do |company|
      Company.new(
        id: company["id"].as_i64,
        name: company["name"].as_s,
        logo_path: company["logo_path"].as_s?,
        origin_country: company["origin_country"].as_s
      )
    end

    @production_countries = data["production_countries"].as_a.map do |country|
      Country.new(country)
    end

    date = data["release_date"].as_s
    @release_date = date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @revenue = data["revenue"].as_i
    @runtime = data["runtime"].as_i

    @spoken_languages = data["spoken_languages"].as_a.map do |lang|
      Language.new(lang)
    end

    @status = Status.parse(data["status"].as_s)
    @tagline = data["tagline"].as_s?
    @title = data["title"].as_s
    @video = data["video"].as_bool
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  def alternative_titles(country : String? = nil) : Array(AlternativeTitle)
    return @alternative_titles.not_nil! unless @alternative_titles.nil?

    filters = Hash(Symbol, String).new
    filters[:country] = country.not_nil! unless country.nil?

    res = Resource.new("/movie/#{id}/alternative_titles", filters)
    @alternative_titles = res.get["titles"].as_a.map do |title|
      AlternativeTitle.new(title)
    end
  end

  def cast(language : String? = nil) : Array(CastCredit)
    return @cast.not_nil! unless @cast.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/credits", filters)
    data = res.get

    @cast = data["cast"].as_a.map { |cast| CastCredit.new(cast) }
    @crew = data["crew"].as_a.map { |crew| CrewCredit.new(crew) }

    @cast.not_nil!
  end

  def crew : Array(CrewCredit)
    return @crew.not_nil! unless @crew.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/credits", filters)
    data = res.get

    @cast = data["cast"].as_a.map { |cast| CastCredit.new(cast) }
    @crew = data["crew"].as_a.map { |crew| CrewCredit.new(crew) }

    @crew.not_nil!
  end

  def external_ids : Array(ExternalId)
    return @external_ids.not_nil! unless @external_ids.nil?

    ret = [] of ExternalId
    res = Resource.new("/movie/#{id}/external_ids")
    data = res.get

    ret << ExternalId.new("imdb_id", data["imdb_id"].as_s) if data["imdb_id"].as_s?
    ret << ExternalId.new("facebook_id", data["facebook_id"].as_s) if data["facebook_id"].as_s?
    ret << ExternalId.new("instagram_id", data["instagram_id"].as_s) if data["instagram_id"].as_s?
    ret << ExternalId.new("twitter_id", data["twitter_id"].as_s) if data["twitter_id"].as_s?

    @external_ids = ret
  end

  def backdrops(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Image)
    return @backdrops.not_nil! unless @backdrops.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!
    filters[:include_image_language] = include_image_language.join(",") unless include_image_language.nil?

    res = Resource.new("/movie/#{id}/images", filters)
    data = res.get

    @backdrops = data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
    @posters = data["posters"].as_a.map { |poster| Image.new(poster) }

    @backdrops.not_nil!
  end

  def posters(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Image)
    return @posters.not_nil! unless @posters.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!
    filters[:include_image_language] = include_image_language.join(",") unless include_image_language.nil?

    res = Resource.new("/movie/#{id}/images", filters)
    data = res.get

    @backdrops = data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
    @posters = data["posters"].as_a.map { |poster| Image.new(poster) }

    @posters.not_nil!
  end

  def keywords : Array(Keyword)
    return @keywords.not_nil! unless @keywords.nil?

    res = Resource.new("/movie/#{id}/keywords")
    data = res.get

    @keywords = data["keywords"].as_a.map { |keyword|  Keyword.new(keyword) }
  end

  def recommendations(language : String? = nil) : LazyIterator(MovieResult)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/recommendations", filters)
    LazyIterator(MovieResult).new(res)
  end

  def release_dates : Array(Tuple(String, Array(Release)))
    return @release_dates.not_nil! unless @release_dates.nil?

    res = Resource.new("/movie/#{id}/release_dates")
    data = res.get

    @release_dates = data["results"].as_a.map do |release|
      country_code = release["iso_3166_1"].as_s
      releases = release["release_dates"].as_a.map { |rd| Release.new(rd) }

      {country_code, releases}
    end
  end

  def user_reviews(language : String? = nil) : LazyIterator(Review)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/reviews", filters)
    LazyIterator(Review).new(res)
  end

  def similar_movies(language : String? = nil) : LazyIterator(MovieResult)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/similar", filters)
    LazyIterator(MovieResult).new(res)
  end

  def translations : Array(Translation)
    return @translations.not_nil! unless @translations.nil?

    res = Resource.new("/movie/#{id}/translations")
    data = res.get

    @translations = data["translations"].as_a.map { |tr| Translation.new(tr) }
  end

  def videos(language : String? = nil) : Array(Video)
    return @videos.not_nil! unless @videos.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/movie/#{id}/videos", filters)
    data = res.get

    @videos = data["results"].as_a.map { |video| Video.new(video) }
  end

  def watch_providers : Hash(String, Watch)
    return @watch_providers.not_nil! unless @watch_providers.nil?

    res = Resource.new("/movie/#{id}/watch/providers")
    data = res.get

    ret = Hash(String, Watch).new
    data["results"].as_h.each do |country_code, wp|
      watch = Watch.new

      watch.flatrate = wp["flatrate"].as_a.map { |p| Provider.new(p) } if wp["flatrate"]?
      watch.rent = wp["rent"].as_a.map { |p| Provider.new(p) } if wp["rent"]?
      watch.buy = wp["buy"].as_a.map { |p| Provider.new(p) } if wp["buy"]?

      ret[country_code] = watch
    end

    @watch_providers = ret
  end
end
