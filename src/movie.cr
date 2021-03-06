require "./collection"
require "./genre"
require "./company"
require "./country"
require "./language"
require "./alternative_title"
require "./movie/cast"
require "./movie/crew"
require "./image"
require "./release"
require "./review"
require "./translation"
require "./video"
require "./watch"
require "./keyword"
require "./external_id"
require "./filter_factory"
require "./image_urls"
require "./change"

class Tmdb::Movie
  include ImageUrls

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
  getter id : Int64
  getter original_language : String
  getter original_title : String
  getter overview : String?
  getter popularity : Float64
  getter poster_path : String?
  getter production_companies : Array(Company)
  getter production_countries : Array(Country)
  getter release_date : Time?
  getter revenue : Int64
  getter runtime : Int32?
  getter spoken_languages : Array(Language)
  getter status : Status
  getter title : String
  getter? video : Bool
  getter vote_average : Float64
  getter vote_count : Int32
  @homepage : String?
  @imdb_id : String?
  @tagline : String?

  # Get the primary information about a movie.
  def self.detail(id : Int64, language : String? = nil) : Movie
    res = Resource.new("/movie/#{id}", FilterFactory.create_language(language))
    Movie.new(res.get)
  end

  # Get the most newly created movie. This is a live response and will
  # continuously change.
  def self.latest(language : String? = nil, skip_cache : Bool = false) : Movie
    res = Resource.new("/movie/latest", FilterFactory.create_language(language))
    Movie.new(res.get(skip_cache))
  end

  # Get a list of movies in theatres. This is a release type query that looks
  # for all movies that have a release type of 2 or 3 within the specified date
  # range.
  #
  # You can optionally specify a `region` prameter which will narrow the search
  # to only look for theatrical release dates within the specified country.
  def self.now_playing(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(MovieResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/movie/now_playing", filters)
    LazyIterator(MovieResult).new(res, skip_cache: skip_cache)
  end

  # Get a list of the current popular movies on TMDB. This list updates daily.
  def self.popular(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(MovieResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/movie/popular", filters)
    LazyIterator(MovieResult).new(res, skip_cache: skip_cache)
  end

  # Get the top rated movies on TMDB.
  def self.top_rated(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(MovieResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/movie/top_rated", filters)
    LazyIterator(MovieResult).new(res, skip_cache: skip_cache)
  end

  # Get a list of upcoming movies in theatres. This is a release type query that
  # looks for all movies that have a release type of 2 or 3 within the specified
  # date range.
  #
  # You can optionally specify a `region` prameter which will narrow the search
  # to only look for theatrical release dates within the specified country.
  def self.upcoming(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(MovieResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/movie/upcoming", filters)
    LazyIterator(MovieResult).new(res, skip_cache: skip_cache)
  end

  def initialize(data : JSON::Any)
    @adult = data["adult"].as_bool
    @backdrop_path = data["backdrop_path"].as_s?

    btc = data["belongs_to_collection"]
    @belongs_to_collection = Collection.new(
      id: btc["id"].as_i64,
      name: btc["name"].as_s,
      poster_path: btc["poster_path"].as_s?,
      backdrop_path: btc["backdrop_path"].as_s?
    ) if btc.as_h?

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
    @revenue = data["revenue"].as_i64
    @runtime = data["runtime"].as_i?
    @spoken_languages = data["spoken_languages"].as_a.map { |lang| Language.new(lang) }
    @status = Status.parse(data["status"].as_s.gsub(" ", ""))
    @tagline = data["tagline"].as_s?
    @title = data["title"].as_s
    @video = data["video"].as_bool
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  def homepage : String?
    @homepage.try(&.empty?) ? nil : @homepage  # treat empty strings as nil
  end

  def imdb_id : String?
    @imdb_id.try(&.empty?) ? nil : @imdb_id  # treat empty strings as nil
  end

  def tagline : String?
    @tagline.try(&.empty?) ? nil : @tagline  # treat empty strings as nil
  end

  # Get all of the alternative titles for a movie.
  def alternative_titles(country : String? = nil) : Array(AlternativeTitle)
    res = Resource.new("/movie/#{id}/alternative_titles", FilterFactory.create_country(country))
    res.get["titles"].as_a.map { |title| AlternativeTitle.new(title) }
  end

  # Get the changes for a movie. By default only the last 24 hours are returned.
  #
  # You can query up to 14 days in a single query by using the `start_date` and
  # `end_date` query parameters.
  def changes(start_date : Time? = nil, end_date : Time? = nil) : Array(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/movie/#{id}/changes", filters)
    data = res.get

    data["changes"].as_a.map { |change| Change.new(change) }
  end

  # Get the cast and crew for a movie.
  def credits(language : String? = nil) : Array(Movie::Cast | Movie::Crew)
    res = Resource.new("/movie/#{id}/credits", FilterFactory.create_language(language))
    data = res.get
    ret = [] of Movie::Cast | Movie::Crew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Movie::Cast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Movie::Crew.new(crew) }

    ret
  end

  def cast(language : String? = nil) : Array(Movie::Cast)
    credits(language).select(Movie::Cast)
  end

  def crew(language : String? = nil) : Array(Movie::Crew)
    credits(language).select(Movie::Crew)
  end

  # Get the external ids for a movie. We currently support the following
  # external sources.
  #
  # * IMDb ID
  # * Facebook
  # * Instagram
  # * Twitter
  def external_ids : Array(ExternalId)
    ret = [] of ExternalId
    res = Resource.new("/movie/#{id}/external_ids")
    data = res.get

    %w(imdb_id facebook_id instagram_id twitter_id).each do |provider|
      ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
    end

    ret
  end

  # Get the images that belong to a movie.
  #
  # Querying images with a `language` parameter will filter the results. If you
  # want to include a fallback language (especially useful for backdrops) you
  # can use the `include_image_language` parameter. This should be a comma
  # seperated value like so: `include_image_language=en,null`.
  def images(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Backdrop | Poster)
    filters = FilterFactory.create_language(language)
    filters[:include_image_language] = include_image_language.join(",") unless include_image_language.nil?

    res = Resource.new("/movie/#{id}/images", filters)
    ret = [] of Backdrop | Poster

    res.get["backdrops"].as_a.reduce(ret) { |ret, backdrop| ret << Backdrop.new(backdrop) }
    res.get["posters"].as_a.reduce(ret) { |ret, poster| ret << Poster.new(poster) }

    ret
  end

  # See `#images`
  def backdrops(language : String? = nil, include_image_language : Array(String)? = nil) : Array(Backdrop)
    images(language, include_image_language).select(Backdrop)
  end

  # See `#images`
  def posters(language : String? = nil, include_image_language : Array(String)?  = nil) : Array(Poster)
    images(language, include_image_language).select(Poster)
  end

  # Get the keywords that have been added to a movie.
  def keywords : Array(Keyword)
    res = Resource.new("/movie/#{id}/keywords")
    res.get["keywords"].as_a.map { |keyword|  Keyword.new(keyword) }
  end

  # Get a list of recommended movies for a movie.
  def recommendations(language : String? = nil) : LazyIterator(MovieResult)
    res = Resource.new("/movie/#{id}/recommendations", FilterFactory.create_language(language))
    LazyIterator(MovieResult).new(res)
  end

  # Get the release date along with the certification for a movie.
  def release_dates : Array(Tuple(String, Array(Release)))
    res = Resource.new("/movie/#{id}/release_dates")

    res.get["results"].as_a.map do |release|
      country_code = release["iso_3166_1"].as_s
      releases = release["release_dates"].as_a.map { |rd| Release.new(rd) }

      {country_code, releases}
    end
  end

  # Get the user reviews for a movie.
  def user_reviews(language : String? = nil) : LazyIterator(Review)
    res = Resource.new("/movie/#{id}/reviews", FilterFactory.create_language(language))
    LazyIterator(Review).new(res)
  end

  # Get a list of similar movies. This is not the same as the "Recommendation"
  # system you see on the website.
  #
  # These items are assembled by looking at keywords and genres.
  def similar_movies(language : String? = nil) : LazyIterator(MovieResult)
    res = Resource.new("/movie/#{id}/similar", FilterFactory.create_language(language))
    LazyIterator(MovieResult).new(res)
  end

  # Get a list of translations that have been created for a movie.
  def translations : Array(Translation)
    res = Resource.new("/movie/#{id}/translations")
    res.get["translations"].as_a.map { |tr| Translation.new(tr) }
  end

  # Get the videos that have been added to a movie.
  def videos(language : String? = nil) : Array(Video)
    res = Resource.new("/movie/#{id}/videos", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |video| Video.new(video) }
  end

  # Powered by our partnership with JustWatch, you can query this method to get
  # a list of the availabilities per country by provider.
  #
  # This is **not** going to return full deep links, but rather, it's just
  # enough information to display what's available where.
  #
  # You can link to the provided TMDB URL to help support TMDB and provide the
  # actual deep links to the content.
  #
  # **Please note**: In order to use this data **you must** attribute the
  # source of the data as JustWatch. If we find any usage not complying
  # with these terms we will revoke access to the API.
  def watch_providers : Hash(String, Watch)
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
