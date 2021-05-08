require "./api"
require "./resource"
require "./search"
require "./configuration"
require "./certification"
require "./collection"
require "./company"
require "./credit"
require "./keyword"
require "./tv/show"
require "./tv/season"
require "./tv/episode"
require "./tv/episode_group"
require "./cache/file_cache"
require "./changes"
require "./discover"
require "./find"
require "./trending"

module Tmdb
  VERSION = `cat VERSION`.strip
  @@api : Api = Api.new

  def self.configure
    api = Api.new
    yield api
    @@api = api
  end

  def self.api : Api
    @@api
  end

  def self.parse_date(data : JSON::Any) : Time?
    date = data.as_s?
    (date.nil? || date.not_nil!.empty?) ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)
  end

  macro memoize(var)
    return @{{ var.id }}.not_nil! unless @{{ var.id }}.nil?
    @{{ var.id }} = {{ yield }}
  end
end
