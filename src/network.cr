class Tmdb::Network
  getter id : Int64
  getter logo_path : String?
  getter name : String
  getter origin_country : String

  @headquarters : String? = nil
  @homepage : String? = nil

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

  private def refresh!
  end
end
