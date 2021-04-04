require "http"
require "json"

module Tmdb
  class NotFound < Exception; end
  class Unauthorized < Exception; end
end

class Tmdb::Resource
  getter query_url : String
  getter api : Api
  property params : Hash(Symbol, String)

  def initialize(@query_url : String, @params : Hash(Symbol, String), @api : Api = Tmdb.api)
  end

  def get
    request_params = api.params
    request_params.merge!(params)
    uri = api.make_uri(query_url, request_params)

    resp = HTTP::Client.exec url: uri.to_s, method: "GET", headers: api.json_headers
    data = JSON.parse resp.body

    case resp.status_code
    when 404
      raise NotFound.new data["status_message"].as_s
    when 401
      raise Unauthorized.new data["status_message"].as_s
    end

    data
  end
end
