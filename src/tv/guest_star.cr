require "../credit"

class Tmdb::Tv::GuestStar
  getter id : Int64
  getter name : String
  getter credit_id : String
  getter character : String
  getter order : Int32
  getter profile_path : String?

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @credit_id = data["credit_id"].as_s
    @character = data["character"].as_s
    @order = data["order"].as_i
    @profile_path = data["profile_path"].as_s
  end

  def credit : Credit
    Credit.detail credit_id
  end
end
