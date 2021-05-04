require "./logo_urls"

class Tmdb::Provider
  include LogoUrls

  getter display_priority : Int32
  getter logo_path : String
  getter id : Int32
  getter name : String

  def initialize(data : JSON::Any)
    @display_priority = data["display_priority"].as_i
    @logo_path = data["logo_path"].as_s
    @id = data["provider_id"].as_i
    @name = data["provider_name"].as_s
  end
end
