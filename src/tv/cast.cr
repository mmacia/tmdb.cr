require "../credit"
require "./cast_base"

class Tmdb::Tv::Cast < Tmdb::Tv::CastBase
  getter character : String
  getter credit_id : String

  def initialize(data : JSON::Any)
    super(data)

    @character = data["character"].as_s
    @credit_id = data["credit_id"].as_s
  end

  def credit : Credit
    Credit.detail credit_id
  end
end
