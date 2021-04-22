require "./image"

class Tmdb::Network
  getter id : Int64
  getter logo_path : String?
  getter name : String
  getter origin_country : String

  @headquarters : String? = nil
  @homepage : String? = nil
  @alternative_names : Array(String)? = nil
  @images : Array(Image)? = nil

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

  def alternative_names : Array(String)
    Tmdb.memoize :alternative_names do
      res = Resource.new("/network/#{id}/alternative_names")
      res.get["results"].as_a.map { |result| result["name"].as_s }
    end
  end

  def images : Array(Image)
    Tmdb.memoize :images do
      res = Resource.new("/network/#{id}/images")
      res.get["logos"].as_a.map { |logo| Image.new(logo) }
    end
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
