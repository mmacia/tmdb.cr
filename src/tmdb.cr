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
require "./watch_provider"

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
    # solve date quirks
    date = date.gsub(".", "-").gsub(/^1-16-2016$/, "16-01-2016") unless date.nil?
    (date.nil? || date.not_nil!.empty?) ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)
  rescue e : ArgumentError
    # fix bad time: 2007-04-00 -> 2007-04-01
    Time.parse(date.not_nil!.gsub(/-00$|-0$/, "-01"), "%Y-%m-%d", Time::Location::UTC)
  end

  def self.resilient_parse_int32(data : JSON::Any) : Int32
    data.as_i
  rescue TypeCastError
    data.as_f.to_i
  end

  def self.resilient_parse_int64(data : JSON::Any) : Int64
    data.as_i64
  rescue TypeCastError
    data.as_f.to_i64
  end

  def self.resilient_parse_float64(data : JSON::Any) : Float64
    data.as_f
  rescue TypeCastError
    data.as_i64.to_f64
  end
end
