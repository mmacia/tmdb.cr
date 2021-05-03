require "./crew"
require "./cast"
require "./guest_star"
require "../filter_factory"
require "../external_id"

class Tmdb::Tv::Episode
  class Change
    class Item
      getter id : String
      getter action : String
      getter time : Time
      getter iso_639_1 : String?
      getter value : String
      getter original_value : String?

      def initialize(data : JSON::Any)
        @id = data["id"].as_s
        @action = data["action"].as_s
        @time = Time.parse(data["time"].as_s, "%Y-%m-%d %H:%M:%s", Time::Location::UTC)
        @iso_639_1 = data["iso_639_1"]? ? data["iso_639_1"].as_s : nil
        @value = data["value"].to_json

        if data["original_value"]?
          @original_value = data["original_value"].to_json
        else
          @original_value = nil
        end
      end
    end

    getter key : String
    getter items : Array(Item)

    def initialize(data : JSON::Any)
      @key = data["key"].as_s
      @items = data["items"].as_a.map { |item| Item.new(item) }
    end
  end

  getter air_date : Time?
  getter episode_number : Int32
  getter name : String
  getter overview : String
  getter id : Int64
  getter production_code : String?
  getter season_number : Int32
  getter still_path : String?
  getter vote_average : Float64
  getter vote_count : Int32
  getter show_id : Int64
  getter order : Int32?

  @crew : Array(Crew)? = nil
  @guest_stars : Array(GuestStar)? = nil
  @credits : Array(Crew | Cast | GuestStar)? = nil
  @translations : Array(Translation)? = nil
  @external_ids : Array(ExternalId)? = nil
  @images : Array(Image)? = nil
  @videos : Array(Video)? = nil

  # Get the TV episode details by id.
  def self.detail(show_id : Int64, season_number : Int32, episode_number : Int32, language : String? = nil) : Episode
    url = "/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}"
    res = Resource.new(url, FilterFactory.create_language(language))
    Tv::Episode.new(res.get, show_id)
  end

  def initialize(data : JSON::Any, @show_id : Int64)
    @air_date = Tmdb.parse_date(data["air_date"])
    @crew = data["crew"].as_a.map { |crew| Crew.new(crew) } if data["crew"]?
    @episode_number = data["episode_number"].as_i
    @guest_stars = data["guest_stars"].as_a.map { |guest_star| GuestStar.new(guest_star) } if data["guest_stars"]?
    @name = data["name"].as_s
    @overview = data["overview"].as_s
    @id = data["id"].as_i64
    @production_code = data["production_code"].as_s?
    @season_number = data["season_number"].as_i
    @still_path = data["still_path"].as_s?
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
    @order = data["order"]? ? data["order"].as_i : nil
  end

  def crew : Array(Crew)
    refresh! if @crew.nil?
    @crew.not_nil!
  end

  def guest_stars : Array(GuestStar)
    refresh! if @guest_stars.nil?
    @guest_stars.not_nil!
  end

  # Get the changes for a TV episode. By default only the last 24 hours are
  # returned.
  #
  # You can query up to 14 days in a single query by using the `start_date` and
  # `end_date` query parameters.
  def changes(start_date : Time? = nil, end_date : Time? = nil) : Array(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/tv/episode/#{id}/changes", filters)
    data = res.get

    data["changes"].as_a.map { |change| Change.new(change) }
  end

  # Get the credits (cast, crew and guest stars) for a TV episode.
  def credits(language : String? = nil) : Array(Crew | Cast | GuestStar)
    Tmdb.memoize :credits do
      url = "/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}"
      res = Resource.new(url, FilterFactory.create_language(language))
      data = res.get
      ret = [] of Cast | Crew | GuestStar

      data["cast"].as_a.reduce(ret) { |ret, cast| ret << Cast.new(cast) } if data["cast"]?
      data["crew"].as_a.reduce(ret) { |ret, crew| ret << Crew.new(crew) } if data["crew"]?
      data["guest_stars"].as_a.reduce(ret) { |ret, guest_star| ret << GuestStar.new(guest_star) } if data["guest_stars"]?

      ret
    end
  end

  # Get the external ids for a TV episode. We currently support the following
  # external sources.
  #
  # * IMDb ID
  # * TVDB ID
  # * Freebase MID\*
  # * Freebase ID\*
  # * TVRage ID\*
  #
  # \*Defunct or no longer available as a service.
  def external_ids : Array(ExternalId)
    Tmdb.memoize :external_ids do
      res = Resource.new("/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}/external_ids")
      data = res.get
      ret = [] of ExternalId

      %w(imdb_id freebase_mid freebase_id tvdb_id tvrage_id).each do |provider|
        ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
      end

      ret
    end
  end

  # Get the images that belong to a TV episode.
  #
  # Querying images with a `language` parameter will filter the results. If you
  # want to include a fallback language (especially useful for backdrops) you
  # can use the `include_image_language` parameter. This should be a comma
  # seperated value like so: `include_image_language=en,null`.
  def images : Array(Image)
    Tmdb.memoize :images do
      res = Resource.new("/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}/images")
      res.get["stills"].as_a.map { |still| Image.new(still) }
    end
  end

  # Get the translation data for an episode.
  def translations : Array(Tv::Translation)
    Tmdb.memoize :translations do
      res = Resource.new("/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}/translations")
      res.get["translations"].as_a.map { |tr| Tv::Translation.new(tr) }
    end
  end

  # Get the videos that have been added to a TV episode.
  def videos(language : String? = nil) : Array(Video)
    Tmdb.memoize :videos do
      url = "/tv/#{show_id}/season/#{season_number}/episode/#{episode_number}/videos"
      res = Resource.new(url, FilterFactory.create_language(language))
      res.get["results"].as_a.map { |video| Video.new(video) }
    end
  end

  private def refresh!
    obj = Episode.detail(show_id, season_number, episode_number)

    @air_date = obj.air_date
    @crew = obj.crew
    @episode_number = obj.episode_number
    @guest_stars = obj.guest_stars
    @name = obj.name
    @overview = obj.overview
    @id = obj.id
    @production_code = obj.production_code
    @season_number = obj.season_number
    @still_path = obj.still_path
    @vote_average = obj.vote_average
    @vote_count = obj.vote_count
  end
end
