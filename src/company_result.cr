require "./company"
require "./logo_urls"

class Tmdb::CompanyResult
  include LogoUrls

  getter id : Int64
  getter logo_path : String?
  getter name : String

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @logo_path = data["logo_path"].as_s?
    @name = data["name"].as_s
  end

  def company_detail : Company
    Company.detail(id)
  end
end
