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
    res = Resource.new("/tv/#{id}", FilterFactory.create_language(language))
    Tv::Show.new(res.get)
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

  def aggregated_credits(language : String? = nil) : Array(Tv::AggregatedCast | Tv::AggregatedCrew)
    res = Resource.new("/tv/#{id}/aggregate_credits", FilterFactory.create_language(language))
    data = res.get
    ret = [] of Tv::AggregatedCast | Tv::AggregatedCrew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << Tv::AggregatedCast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << Tv::AggregatedCrew.new(crew) }

    ret
  end

  def alternative_titles(language : String? = nil) : Array(AlternativeTitle)
    res = Resource.new("/tv/#{id}/alternative_titles", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |title| AlternativeTitle.new(title) }
  end

  def content_ratings(language : String? = nil) : Array(Tv::Rating)
    res = Resource.new("/tv/#{id}/content_ratings", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |rating| Tv::Rating.new(rating) }
  end

  def episode_groups(language : String? = nil) : Array(Tv::EpisodeGroupResult)
    res = Resource.new("/tv/#{id}/episode_groups", FilterFactory.create_language(language))
    res.get["results"].as_a.map { |episode_group| Tv::EpisodeGroupResult.new(episode_group) }
  end

  def external_ids(language : String? = nil) : Array(ExternalId)
    res = Resource.new("/tv/#{id}/external_ids", FilterFactory.create_language(language))
    data = res.get
    ret = [] of ExternalId

    %w(imdb_id freebase_mid freebase_id tvdb_id tvrage_id facebook_id instagram_id twitter_id).each do |provider|
      ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
    end

    ret
  end

  def backdrops(language : String? = nil) : Array(Image)
    res = Resource.new("/tv/#{id}/images", FilterFactory.create_language(language))
    res.get["backdrops"].as_a.map { |backdrop| Image.new(backdrop) }
  end

  def posters(language : String? = nil) : Array(Image)
    res = Resource.new("/tv/#{id}/images", FilterFactory.create_language(language))
    res.get["posters"].as_a.map { |poster| Image.new(poster) }
  end

  def keywords : Array(Keyword)
    Tmdb.memoize :keywords do
      res = Resource.new("/tv/#{id}/keywords")
      res.get["results"].as_a.map { |keyword|  Keyword.new(keyword) }
    end
  end

  def recommendations(language : String? = nil) : LazyIterator(ShowResult)
    res = Resource.new("/tv/#{id}/recommendations", FilterFactory.create_language(language))
    LazyIterator(ShowResult).new(res)
  end

  def reviews(language : String? = nil) : LazyIterator(Review)
    res = Resource.new("/tv/#{id}/reviews", FilterFactory.create_language(language))
    LazyIterator(Review).new(res)
  end

  def similar_tv_shows(language : String? = nil) : LazyIterator(ShowResult)
    res = Resource.new("/tv/#{id}/similar", FilterFactory.create_language(language))
    LazyIterator(ShowResult).new(res)
  end

  def translations : Array(Tv::Translation)
    Tmdb.memoize :translations do
      res = Resource.new("/tv/#{id}/translations")
      res.get["translations"].as_a.map { |tr| Tv::Translation.new(tr) }
    end
  end

  def videos(language : String? = nil) : Array(Video)
    Tmdb.memoize :videos do
      res = Resource.new("/tv/#{id}/videos", FilterFactory.create_language(language))
      res.get["results"].as_a.map { |video| Video.new(video) }
    end
  end

  def watch_providers : Hash(String, Watch)
    Tmdb.memoize :watch_providers do
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
end
