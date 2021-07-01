require "./episode"
require "../network"
require "./season"
require "./aggregated_cast"
require "./aggregated_crew"
require "./rating"
require "./episode_group_result"
require "./translation"
require "../alternative_title"
require "../external_id"
require "../review"
require "../filter_factory"
require "../image_urls"
require "../change"

class Tmdb::Tv::Show
  include ImageUrls

  enum Type
    News
    Scripted
    Documentary
    TalkShow
    Reality
    Miniseries
    Video
  end

  enum Status
    InProduction
    Pilot
    Planned
    Canceled
    Ended
    ReturningSeries
  end

  getter backdrop_path : String?
  getter created_by : Array(Credit)
  getter episode_run_time : Array(Int32)
  getter first_air_date : Time?
  getter genres : Array(Genre)
  getter homepage : String
  getter id : Int64
  getter? in_production : Bool
  getter languages : Array(String)
  getter last_air_date : Time?
  getter last_episode_to_air : Tv::Episode?
  getter name : String
  getter next_episode_to_air : Int32?
  getter networks : Array(Network)
  getter number_of_episodes : Int32?
  getter number_of_seasons : Int32
  getter origin_country : Array(String)
  getter original_language : String
  getter original_name : String
  getter overview : String
  getter popularity : Float64
  getter poster_path : String?
  getter production_companies : Array(CompanyResult)
  getter production_countries : Array(Country)
  getter seasons : Array(Tv::Season)
  getter spoken_languages : Array(Language)
  getter status : Status
  getter tagline : String
  getter type : Type
  getter vote_average : Float64
  getter vote_count : Int32

  # Get the primary TV show details by id.
  def self.detail(id : Int64, language : String? = nil) : Show
    res = Resource.new("/tv/#{id}", FilterFactory.create_language(language))
    Tv::Show.new(res.get)
  end

  def self.latest(language : String? = nil, skip_cache : Bool = false) : Show
    res = Resource.new("/tv/latest", FilterFactory.create_language(language))
    Show.new(res.get(skip_cache))
  end

  # Get a list of TV shows that are airing today. This query is purely day
  # based as we do not currently support airing times.
  def self.airing_today(language : String? = nil, skip_cache : Bool = false) : LazyIterator(ShowResult)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/tv/airing_today", filters)
    LazyIterator(ShowResult).new(res, skip_cache: skip_cache)
  end

  # Get a list of shows that are currently on the air.
  #
  # This query looks for any TV show that has an episode with an air date in
  # the next 7 days.
  def self.on_the_air(language : String? = nil, skip_cache : Bool = false) : LazyIterator(ShowResult)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/tv/on_the_air", filters)
    LazyIterator(ShowResult).new(res, skip_cache: skip_cache)
  end

  # Get a list of the current popular TV shows on TMDB. This list updates daily.
  def self.popular(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(ShowResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/tv/popular", filters)
    LazyIterator(ShowResult).new(res, skip_cache: skip_cache)
  end

  # Get the top rated TV shows on TMDB.
  def self.top_rated(
    language : String? = nil,
    region : String? = nil,
    skip_cache : Bool = false
  ) : LazyIterator(ShowResult)
    filters = FilterFactory.create_language(language)
    filters[:region] = region.not_nil! unless region.nil?

    res = Resource.new("/tv/top_rated", filters)
    LazyIterator(ShowResult).new(res, skip_cache: skip_cache)
  end

  def initialize(data : JSON::Any)
    @backdrop_path = data["backdrop_path"].as_s?
    @created_by = data["created_by"].as_a.map { |credit| Credit.detail(credit["credit_id"].as_s) }
    @episode_run_time = data["episode_run_time"].as_a.map(&.as_i)
    @first_air_date = Tmdb.parse_date(data["first_air_date"])
    @genres = data["genres"].as_a.map { |genre| Genre.new(genre) }
    @homepage = data["homepage"].as_s
    @id = data["id"].as_i64
    @in_production = data["in_production"].as_bool
    @languages = data["languages"].as_a.map(&.as_s)
    @last_air_date = Tmdb.parse_date(data["last_air_date"])
    @last_episode_to_air = Tv::Episode.new(data["last_episode_to_air"], id) unless data["last_episode_to_air"]?
    @name = data["name"].as_s
    @next_episode_to_air = data["next_episode_to_air"].as_i?
    @networks = data["networks"].as_a.map { |network| Network.new(network) }
    @number_of_episodes = data["number_of_episodes"].as_i?
    @number_of_seasons = data["number_of_seasons"].as_i
    @origin_country = data["origin_country"].as_a.map(&.as_s)
    @original_language = data["original_language"].as_s
    @original_name = data["original_name"].as_s
    @overview = data["overview"].as_s
    @popularity = data["popularity"].as_f
    @poster_path = data["poster_path"].as_s?
    @production_companies = data["production_companies"].as_a.map { |company| CompanyResult.new(company) }
    @production_countries = data["production_countries"].as_a.map { |country| Country.new(country) }
    @seasons = data["seasons"].as_a.map { |season| Tv::Season.new(season, id) }
    @spoken_languages = data["spoken_languages"].as_a.map { |lang| Language.new(lang) }
    @status = Status.parse(data["status"].as_s.gsub(" ", ""))
    @tagline = data["tagline"].as_s
    @type = Type.parse(data["type"].as_s.gsub(" ", ""))
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  # Get the aggregate credits (cast and crew) that have been added to a TV show.
  #
  # This call differs from the main `#credits` call in that it does not return
  # the newest season but rather, is a view of all the entire cast & crew for
  # all episodes belonging to a TV show.
  def aggregated_credits(language : String? = nil) : Array(Tv::AggregatedCast | Tv::AggregatedCrew)
    res = Resource.new("/tv/#{id}/aggregate_credits", FilterFactory.create_language(language))
    data = res.get
    ret = [] of Tv::AggregatedCast | Tv::AggregatedCrew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Tv::AggregatedCast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Tv::AggregatedCrew.new(crew) }

    ret
  end

  # Returns all of the alternative titles for a TV show.
  def alternative_titles(language : String? = nil) : Array(AlternativeTitle)
    res = Resource.new("/tv/#{id}/alternative_titles", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |title| AlternativeTitle.new(title) }
  end

  # Get the changes for a TV show. By default only the last 24 hours are
  # returned.
  #
  # You can query up to 14 days in a single query by using the `start_date` and
  # `end_date` query parameters.
  #
  # TV show changes are different than movie changes in that there are some
  # edits on seasons and episodes that will create a change entry at the show
  # level. These can be found under the season and episode keys. These keys
  # will contain a `series_id` and `episode_id`. You can use the
  # [season changes](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-changes)
  # and [episode changes](https://developers.themoviedb.org/3/tv-episodes/get-tv-episode-changes)
  # methods to look these up individually.
  def changes(start_date : Time? = nil, end_date : Time? = nil) : Array(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/tv/#{id}/changes", filters)
    data = res.get

    data["changes"].as_a.map { |change| Change.new(change) }
  end

  # Get the list of content ratings (certifications) that have been added to a
  # TV show.
  def content_ratings(language : String? = nil) : Array(Tv::Rating)
    res = Resource.new("/tv/#{id}/content_ratings", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |rating| Tv::Rating.new(rating) }
  end

  # Get the credits (cast and crew) that have been added to a TV show.
  def credits(language : String? = nil) : Array(Cast | Crew)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/tv/#{id}/credits")
    data = res.get
    ret = [] of Cast | Crew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Cast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Crew.new(crew) }

    ret
  end

  # Get all of the episode groups that have been created for a TV show. With a
  # group ID you can call the `Tmdb::Tv::EpisodeGroup.detail` method.
  def episode_groups(language : String? = nil) : Array(Tv::EpisodeGroupResult)
    res = Resource.new("/tv/#{id}/episode_groups", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |episode_group| Tv::EpisodeGroupResult.new(episode_group) }
  end

  # Get the external ids for a TV show. We currently support the following
  # external sources.
  #
  # * IMDb ID
  # * TVDB ID
  # * Freebase MID\*
  # * Freebase ID\*
  # * TVRage ID\*
  # * Facebook
  # * Instagram
  # * Twitter
  #
  # \* Defunct or no longer available as a service
  def external_ids(language : String? = nil) : Array(ExternalId)
    res = Resource.new("/tv/#{id}/external_ids", FilterFactory.create_language(language))
    data = res.get
    ret = [] of ExternalId

    %w(imdb_id freebase_mid freebase_id tvdb_id tvrage_id facebook_id instagram_id twitter_id).each do |provider|
      ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
    end

    ret
  end

  # Get the images that belong to a TV show.
  #
  # Querying images with a `language` parameter will filter the results. If you
  # want to include a fallback language (especially useful for backdrops) you
  # can use the `include_image_language` parameter. This should be a comma
  # seperated value like so: `include_image_language=en,null`.
  def images(language : String? = nil) : Array(Backdrop | Poster)
    res = Resource.new("/tv/#{id}/images", FilterFactory.create_language(language))
    ret = [] of Backdrop | Poster

    res.get["backdrops"].as_a.reduce(ret) { |ret, backdrop| ret << Backdrop.new(backdrop) }
    res.get["posters"].as_a.reduce(ret) { |ret, poster| ret << Poster.new(poster) }

    ret
  end

  # See `#images`
  def backdrops(language : String? = nil) : Array(Backdrop)
    images(language).select(Backdrop)
  end

  # See `#images`
  def posters(language : String? = nil) : Array(Poster)
    images(language).select(Poster)
  end

  # Get the keywords that have been added to a TV show.
  def keywords : Array(Keyword)
    res = Resource.new("/tv/#{id}/keywords")
    res.get["results"].as_a.map { |keyword|  Keyword.new(keyword) }
  end

  # Get the list of TV show recommendations for this item.
  def recommendations(language : String? = nil) : LazyIterator(ShowResult)
    res = Resource.new("/tv/#{id}/recommendations", FilterFactory.create_language(language))
    LazyIterator(ShowResult).new(res)
  end

  # Get the reviews for a TV show.
  def reviews(language : String? = nil) : LazyIterator(Review)
    res = Resource.new("/tv/#{id}/reviews", FilterFactory.create_language(language))
    LazyIterator(Review).new(res)
  end

  # Get a list of seasons or episodes that have been screened in a film festival
  # or theatre.
  def screened_theatrically : Array(NamedTuple(episode_number: Int32, season_number: Int32))
    res = Resource.new("/tv/#{id}/screened_theatrically")
    data = res.get

    data["results"].as_a.map do |result|
      { episode_number: result["episode_number"].as_i,
        season_number: result["season_number"].as_i }
    end
  end

  # Get a list of similar TV shows. These items are assembled by looking at
  # keywords and genres.
  def similar_tv_shows(language : String? = nil) : LazyIterator(ShowResult)
    res = Resource.new("/tv/#{id}/similar", FilterFactory.create_language(language))
    LazyIterator(ShowResult).new(res)
  end

  # Get a list of the translations that exist for a TV show.
  def translations : Array(Tv::Translation)
    res = Resource.new("/tv/#{id}/translations")
    res.get["translations"].as_a.map { |tr| Tv::Translation.new(tr) }
  end

  # Get the videos that have been added to a TV show.
  def videos(language : String? = nil) : Array(Video)
    res = Resource.new("/tv/#{id}/videos", FilterFactory.create_language(language))
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
    res = Resource.new("/tv/#{id}/watch/providers")
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
