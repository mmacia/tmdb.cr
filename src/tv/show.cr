require "./episode"
require "../network"
require "./season"
require "./cast"
require "./crew"
require "./rating"
require "./episode_group_result"
require "./translation"
require "../alternative_title"
require "../external_id"
require "../review"

class Tmdb::Tv::Show
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

  @keywords : Array(Keyword)? = nil
  @translations : Array(Tv::Translation)? = nil
  @videos : Array(Video)? = nil
  @watch_providers : Hash(String, Watch)? = nil

  def self.detail(id : Int64, language : String? = nil) : Show
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}", filters)
    Tv::Show.new(res.get)
  end

  def initialize(data : JSON::Any)
    @backdrop_path = data["backdrop_path"].as_s?

    @created_by = data["created_by"].as_a.map do |credit|
      Credit.detail(credit["credit_id"].as_s)
    end

    @episode_run_time = data["episode_run_time"].as_a.map(&.as_i)

    date = data["first_air_date"].as_s?
    @first_air_date = date.nil? || date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @genres = data["genres"].as_a.map do |genre|
      Genre.new(genre)
    end

    @homepage = data["homepage"].as_s
    @id = data["id"].as_i64
    @in_production = data["in_production"].as_bool
    @languages = data["languages"].as_a.map(&.as_s)

    date = data["last_air_date"].as_s?
    @last_air_date = date.nil? || date.empty? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    @last_episode_to_air = Tv::Episode.new(data["last_episode_to_air"]) unless data["last_episode_to_air"]?
    @name = data["name"].as_s
    @next_episode_to_air = data["next_episode_to_air"].as_i?

    @networks = data["networks"].as_a.map do |network|
      Network.new(network)
    end

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
    @seasons = data["seasons"].as_a.map { |season| Tv::Season.new(season) }
    @spoken_languages = data["spoken_languages"].as_a.map { |lang| Language.new(lang) }
    @status = Status.parse(data["status"].as_s.gsub(" ", ""))
    @tagline = data["tagline"].as_s
    @type = Type.parse(data["type"].as_s.gsub(" ", ""))
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  def aggregated_credits(language : String? = nil) : Array(Tv::Cast|Tv::Crew)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/aggregate_credits", filters)
    ret = [] of Tv::Cast | Tv::Crew
    data = res.get

    data["cast"].as_a.each do |cast|
      ret << Tv::Cast.new(cast)
    end

    data["crew"].as_a.each do |crew|
      ret << Tv::Crew.new(crew)
    end

    ret
  end

  def alternative_titles(language : String? = nil) : Array(AlternativeTitle)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/alternative_titles", filters)
    res.get["results"].as_a.map { |title| AlternativeTitle.new(title) }
  end

  def content_ratings(language : String? = nil) : Array(Tv::Rating)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/content_ratings", filters)
    res.get["results"].as_a.map { |rating| Tv::Rating.new(rating) }
  end

  def episode_groups(language : String? = nil) : Array(Tv::EpisodeGroupResult)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/episode_groups")
    data = res.get

    data["results"].as_a.map do |episode_group|
      Tv::EpisodeGroupResult.new(episode_group)
    end
  end

  def external_ids(language : String? = nil) : Array(ExternalId)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/external_ids")
    data = res.get
    ret = [] of ExternalId

    ret << ExternalId.new("imdb_id", data["imdb_id"].as_s) if data["imdb_id"].as_s?
    ret << ExternalId.new("freebase_mid", data["freebase_mid"].as_s) if data["freebase_mid"].as_s?
    ret << ExternalId.new("freebase_id", data["freebase_id"].as_s) if data["freebase_id"].as_s?
    ret << ExternalId.new("tvdb_id", data["tvdb_id"].as_i.to_s) if data["tvdb_id"].as_i?
    ret << ExternalId.new("tvrage_id", data["tvrage_id"].as_i.to_s) if data["tvrage_id"].as_i?
    ret << ExternalId.new("facebook_id", data["facebook_id"].as_s) if data["facebook_id"].as_s?
    ret << ExternalId.new("instagram_id", data["instagram_id"].as_s) if data["instagram_id"].as_s?
    ret << ExternalId.new("twitter_id", data["twitter_id"].as_s) if data["twitter_id"].as_s?

    ret
  end

  def backdrops(language : String? = nil) : Array(Image)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/images", filters)
    data = res.get

    data["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
  end

  def posters(language : String? = nil) : Array(Image)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/images", filters)
    data = res.get

    data["posters"].as_a.map { |poster| Image.new(poster) }
  end

  def keywords : Array(Keyword)
    return @keywords.not_nil! unless @keywords.nil?

    res = Resource.new("/tv/#{id}/keywords")
    data = res.get

    @keywords = data["results"].as_a.map { |keyword|  Keyword.new(keyword) }
  end

  def recommendations(language : String? = nil) : LazyIterator(ShowResult)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/recommendations", filters)
    LazyIterator(ShowResult).new(res)
  end

  def reviews(language : String? = nil) : LazyIterator(Review)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/reviews", filters)
    LazyIterator(Review).new(res)
  end

  def similar_tv_shows(language : String? = nil) : LazyIterator(ShowResult)
    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/similar", filters)
    LazyIterator(ShowResult).new(res)
  end

  def translations : Array(Tv::Translation)
    return @translations.not_nil! unless @translations.nil?

    res = Resource.new("/tv/#{id}/translations")
    data = res.get

    @translations = data["translations"].as_a.map { |tr| Tv::Translation.new(tr) }
  end

  def videos(language : String? = nil) : Array(Video)
    return @videos.not_nil! unless @videos.nil?

    filters = Hash(Symbol, String).new
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/tv/#{id}/videos", filters)
    data = res.get

    @videos = data["results"].as_a.map { |video| Video.new(video) }
  end

  def watch_providers : Hash(String, Watch)
    return @watch_providers.not_nil! unless @watch_providers.nil?

    res = Resource.new("/tv/#{id}/watch/providers")
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
