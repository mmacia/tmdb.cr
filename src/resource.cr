require "http"
require "json"
require "./cache"

module Tmdb
  class NotFound < Exception; end
  class Unauthorized < Exception; end
end

class Tmdb::Resource
  include Cacheable

  getter query_url : String
  getter api : Api = Tmdb.api
  getter params : Hash(Symbol, String)

  def initialize(@query_url : String, params : NamedTuple)
    @params = params.to_h.transform_value(&.to_s)
  end

  def initialize(@query_url : String, @params : Hash(Symbol, String))
  end

  def initialize(@query_url : String)
    @params = Hash(Symbol, String).new
  end

  def get
    request_params = api.params
    request_params.merge!(params)
    uri = api.make_uri(query_url, request_params)

    obj = cache_aware(make_cache_key(uri.to_s, "GET", api.json_headers)) do
      resp = HTTP::Client.exec url: uri.to_s, method: "GET", headers: api.json_headers

      { body: JSON.parse(resp.body),
        status_code: resp.status_code }
    end

    data = obj[:body]
    status_code = obj[:status_code]

    case status_code
    when 404
      raise NotFound.new data["status_message"].as_s
    when 401
      raise Unauthorized.new data["status_message"].as_s
    end

    data
  end
end
