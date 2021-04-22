require "../filter_factory"

class Tmdb::Tv::Season
  getter air_date : Time?
  getter poster_path : String?
  getter season_number : Int32
  getter id : Int64
  getter name : String
  getter overview : String
  getter show_id : Int64

  def self.detail(show_id : Int64, season_number : Int32, language : String? = nil) : Season
    res = Resource.new("/tv/#{show_id}/season/#{season_number}", FilterFactory.create_language(language))
    Season.new(res.get, show_id)
  end

  def initialize(data : JSON::Any, @show_id : Int64)
    @air_date = Tmdb.parse_date(data["air_date"])
    @poster_path = data["poster_path"].as_s?
    @season_number = data["season_number"].as_i
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @overview = data["overview"].as_s
  end

  def aggregated_credits(language : String? = nil) : Array(AggregatedCast | AggregatedCrew)
    url = "/tv/#{show_id}/season/#{season_number}/aggregate_credits"
    res = Resource.new(url, FilterFactory.create_language(language))
    data = res.get
    ret = [] of AggregatedCast | AggregatedCrew

    data["cast"].as_a.reduce(ret) { |ret, cast| ret << AggregatedCast.new(cast) }
    data["crew"].as_a.reduce(ret) { |ret, crew| ret << AggregatedCrew.new(crew) }

    ret
  end

  def external_ids(language : String? = nil) : Array(ExternalId)
    res = Resource.new("/tv/#{show_id}/season/#{season_number}/external_ids", FilterFactory.create_language(language))
    data = res.get
    ret = [] of ExternalId

    %w(freebase_mid freebase_id tvdb_id tvrage_id).each do |provider|
      ret << ExternalId.new(provider, data[provider].as_s) if data[provider].as_s?
    end

    ret
  end

  def images(language : String? = nil) : Array(Image)
    res = Resource.new("/tv/#{show_id}/season/#{season_number}/images", FilterFactory.create_language(language))
    data = res.get

    data["posters"].as_a.map { |poster| Image.new(poster) }
  end

  def translations(language : String? = nil) : Array(Translation)
    res = Resource.new("/tv/#{show_id}/season/#{season_number}/translations", FilterFactory.create_language(language))
    data = res.get

    data["translations"].as_a.map { |tr| Translation.new(tr) }
  end

  def videos(language : String? = nil) : Array(Video)
    res = Resource.new("/tv/#{show_id}/season/#{season_number}/videos", FilterFactory.create_language(language))
    data = res.get

    data["results"].as_a.map { |video| Video.new(video) }
  end
end
