require "./region"
require "./provider"

class Tmdb::WatchProvider
  # Returns a list of all of the countries we have watch provider
  # (OTT/streaming) data for.
  def self.available_regions(language : String? = nil) : Array(Region)
    filters = FilterFactory.create_language(language)

    res = Resource.new("/watch/providers/regions", filters)
    data = res.get

    data["results"].as_a.map { |region| Region.new(region) }
  end

  # Returns a list of the watch provider (OTT/streaming) data we have
  # available for movies. You can specify a `watch_region` param if
  # you want to further filter the list by country.
  def self.movie_providers(language : String? = nil, watch_region : String? = nil) : Array(Provider)
    filters = FilterFactory.create_language(language)
    filters[:watch_region] = watch_region.not_nil!.upcase unless watch_region.nil?

    res = Resource.new("/watch/providers/movie", filters)
    res.get["results"].as_a.map { |provider| Provider.new(provider) }
  end

  # Returns a list of the watch provider (OTT/streaming) data we have
  # available for TV. You can specify a `watch_region` param if
  # you want to further filter the list by country.
  def self.tv_providers(language : String? = nil, watch_region : String? = nil) : Array(Provider)
    filters = FilterFactory.create_language(language)
    filters[:watch_region] = watch_region.not_nil!.upcase unless watch_region.nil?

    res = Resource.new("/watch/providers/tv", filters)
    res.get["results"].as_a.map { |provider| Provider.new(provider) }
  end
end
