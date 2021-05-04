require "http"
require "./filter_factory"
require "./cache"

class Tmdb::Api
  private getter version : String = "3"
  private getter host : String = "api.themoviedb.org"

  property api_key : String = ENV["TMDB_API_KEY"]? || ""
  property default_language : String = "en"
  property cache : Cache(String)? = nil

  def make_uri(path : String, params : Hash(Symbol, String)) : URI
    URI.new("https", host, 443, "#{version}#{path}", make_query_params(params))
  end

  def make_query_params(filters : Tmdb::FilterFactory::Filter) : String
    buf = IO::Memory.new

    filters.reduce(URI::Params::Builder.new(buf)) do |memo, pair|
      memo.add(pair.first.to_s, pair.last)
    end

    buf.to_s
  end

  def params
    FilterFactory.create(
      language: default_language,
      api_key: api_key
    )
  end

  def json_headers : HTTP::Headers
    @json_headers ||= HTTP::Headers{
      "content_ddtype" => "application/json; charset=utf-8",
      "accept" => "application/json",
    }
  end

  def configuration : Configuration
    @configuration ||= Configuration.detail
  end
end
