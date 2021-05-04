require "./image"
require "./logo_urls"

class Tmdb::Network
  include LogoUrls

  getter id : Int64
  getter logo_path : String?
  getter name : String
  getter origin_country : String

  @headquarters : String? = nil
  @homepage : String? = nil
  @alternative_names : Array(String)? = nil
  @images : Array(Logo)? = nil

  # Get the details of a network.
  def self.detail(id : Int64) : Network
    res = Resource.new("/network/#{id}")
    Network.new(res.get)
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @logo_path = data["logo_path"].as_s?
    @name = data["name"].as_s
    @origin_country = data["origin_country"].as_s

    @homepage = data["homepage"].as_s if data["homepage"]?
    @headquarters = data["headquarters"].as_s if data["headquarters"]?
  end

  def headquarters : String
    refresh! if @headquarters.nil?
    @headquarters.not_nil!
  end

  def homepage : String
    refresh! if @homepage.nil?
    @homepage.not_nil!
  end

  # Get the alternative names of a network.
  def alternative_names : Array(String)
    Tmdb.memoize :alternative_names do
      res = Resource.new("/network/#{id}/alternative_names")
      res.get["results"].as_a.map { |result| result["name"].as_s }
    end
  end

  # Get a company logos.
  #
  # There are two image formats that are supported for companies, PNG's and
  # SVG's. You can see which type the original file is by looking at the
  # `file_type` field. We prefer SVG's as they are resolution independent and as
  # such, the width and height are only there to reflect the original asset
  # that was uploaded. An SVG can be scaled properly beyond those dimensions if
  # you call them as a PNG.
  #
  # For more information about how SVG's and PNG's can be used, take a read
  # [through](https://developers.themoviedb.org/3/getting-started/images).
  def images : Array(Logo)
    Tmdb.memoize :images do
      res = Resource.new("/network/#{id}/images")
      res.get["logos"].as_a.map { |logo| Logo.new(logo) }
    end
  end

  # See `#images`
  def logos : Array(Logo)
    images
  end

  private def refresh!
    obj = Network.detail(id)

    @id = obj.id
    @logo_path = obj.logo_path
    @name = obj.name
    @origin_country = obj.origin_country
    @headquarters = obj.headquarters
    @homepage = obj.homepage
  end
end
