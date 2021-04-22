require "../person"
require "../credit"
require "./crew_base"

class Tmdb::Tv::Crew < Tmdb::Tv::CrewBase
  getter job : String
  getter credit_id : String

  def initialize(data : JSON::Any)
    super(data)

    @job = data["job"].as_s
    @credit_id = data["credit_id"].as_s
  end

  def credit : Credit
    Credit.detail credit_id
  end
end
