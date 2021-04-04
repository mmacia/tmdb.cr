require "http"

class Tmdb::Api
  private getter version : String = "3"
  private getter host : String = "api.themoviedb.org"

  property api_key : String = ""
  property default_language : String = "en"

  def make_uri(path : String, params : Hash(Symbol, String)) : URI
    buf = IO::Memory.new

    params.reduce(URI::Params::Builder.new(buf)) do |memo, pair|
      memo.add(pair.first.to_s, pair.last)
    end

    URI.new("https", host, 443, "#{version}#{path}", buf.to_s)
  end

  def params
    {
      language: default_language,
      api_key: api_key
    }.to_h
  end

  def json_headers : HTTP::Headers
    @json_headers ||= HTTP::Headers{
      "content_ddtype" => "application/json; charset=utf-8",
      "accept" => "application/json",
    }
  end
end