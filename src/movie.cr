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
require "./external_id"
require "./filter_factory"

class Tmdb::Movie
  enum Status
    Rumored
    Planned
    InProduction
    PostProduction
    Released
    Canceled
  end

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

  @external_ids : Array(ExternalId)? = nil
  @keywords : Array(Keyword)? = nil
  @release_dates : Array(Tuple(String, Array(Release)))? = nil
  @translations : Array(Translation)? = nil
  @watch_providers : Hash(String, Watch)? = nil

  def self.detail(id : Int64, language : String? = nil) : Movie
    res = Resource.new("/movie/#{id}", FilterFactory.create_language(language))
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
    @genres = data["genres"].as_a.map { |genre| Genre.new(genre) }
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

    @production_countries = data["production_countries"].as_a.map { |country| Country.new(country) }
    @release_date = Tmdb.parse_date(data["release_date"])
    @revenue = data["revenue"].as_i
    @runtime = data["runtime"].as_i
    @spoken_languages = data["spoken_languages"].as_a.map { |lang| Language.new(lang) }
    @status = Status.parse(data["status"].as_s)
    @tagline = data["tagline"].as_s?
    @title = data["title"].as_s
    @video = data["video"].as_bool
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  def alternative_titles(country : String? = nil) : Array(AlternativeTitle)
    res = Resource.new("/movie/#{id}/alternative_titles", FilterFactory.create_country(country))
    res.get["titles"].as_a.map { |title| AlternativeTitle.new(title) }
  end

  def cast(language : String? = nil) : Array(CastCredit)
    res = Resource.new("/movie/#{id}/credits", FilterFactory.create_language(language))
    data = res.get

    data["cast"].as_a.map { |cast| CastCredit.new(cast) }
  end

  def crew(language : String? = nil) : Array(CrewCredit)
    res = Resource.new("/movie/#{id}/credits", FilterFactory.create_language(language))
    data = res.get

    data["crew"].as_a.map { |crew| CrewCredit.new(crew) }
  end

  def external_ids : Array(ExternalId)
    Tmdb.memoize :external_ids do
      ret = [] of ExternalId
      res = Resource.new("/movie/#{id}/external_ids")
      data = res.get

      %w(imdb_id facebook_id instagram_id twitter_id).each do |provider|
        ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
      end

      ret
    end
  end

  def backdrops(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Image)
    filters = FilterFactory.create_language(language)
    filters[:include_image_language] = include_image_language.join(",") unless include_image_language.nil?

    res = Resource.new("/movie/#{id}/images", filters)
    res.get["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
  end

  def posters(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Image)
    filters = FilterFactory.create_language(language)
    filters[:include_image_language] = include_image_language.join(",") unless include_image_language.nil?

    res = Resource.new("/movie/#{id}/images", filters)
    res.get["posters"].as_a.map { |poster| Image.new(poster) }
  end

  def keywords : Array(Keyword)
    Tmdb.memoize :keywords do
      res = Resource.new("/movie/#{id}/keywords")
      res.get["keywords"].as_a.map { |keyword|  Keyword.new(keyword) }
    end
  end

  def recommendations(language : String? = nil) : LazyIterator(MovieResult)
    res = Resource.new("/movie/#{id}/recommendations", FilterFactory.create_language(language))
    LazyIterator(MovieResult).new(res)
  end

  def release_dates : Array(Tuple(String, Array(Release)))
    Tmdb.memoize :release_dates do
      res = Resource.new("/movie/#{id}/release_dates")

      res.get["results"].as_a.map do |release|
        country_code = release["iso_3166_1"].as_s
        releases = release["release_dates"].as_a.map { |rd| Release.new(rd) }

        {country_code, releases}
      end
    end
  end

  def user_reviews(language : String? = nil) : LazyIterator(Review)
    res = Resource.new("/movie/#{id}/reviews", FilterFactory.create_language(language))
    LazyIterator(Review).new(res)
  end

  def similar_movies(language : String? = nil) : LazyIterator(MovieResult)
    res = Resource.new("/movie/#{id}/similar", FilterFactory.create_language(language))
    LazyIterator(MovieResult).new(res)
  end

  def translations : Array(Translation)
    Tmdb.memoize :translations do
      res = Resource.new("/movie/#{id}/translations")
      res.get["translations"].as_a.map { |tr| Translation.new(tr) }
    end
  end

  def videos(language : String? = nil) : Array(Video)
    res = Resource.new("/movie/#{id}/videos", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |video| Video.new(video) }
  end

  def watch_providers : Hash(String, Watch)
    Tmdb.memoize :watch_providers do
      res = Resource.new("/movie/#{id}/watch/providers")
      ret = Hash(String, Watch).new

      res.get["results"].as_h.each do |country_code, wp|
        watch = Watch.new

        watch.flatrate = wp["flatrate"].as_a.map { |p| Provider.new(p) } if wp["flatrate"]?
        watch.rent = wp["rent"].as_a.map { |p| Provider.new(p) } if wp["rent"]?
        watch.buy = wp["buy"].as_a.map { |p| Provider.new(p) } if wp["buy"]?

        ret[country_code] = watch
      end

      ret
    end
  end
end
