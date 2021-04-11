require "./credit"

class Tmdb::CastCredit
  getter original_name : String
  getter credit_id : String
  getter person : Person
  getter cast_id : Int32?
  getter character : String
  getter order : Int32

  def initialize(data : JSON::Any)
    @cast_id = data["cast_id"].as_i
    @character = data["character"].as_s
    @order = data["order"].as_i
    @original_name = data["original_name"].as_s
    @credit_id = data["credit_id"].as_s
    @person = Person.new(
      adult: data["adult"].as_bool,
      gender: data["gender"].as_i,
      id: data["id"].as_i64,
      known_for_department: data["known_for_department"].as_s,
      name: data["name"].as_s,
      popularity: data["popularity"].as_f,
      profile_path: data["profile_path"].as_s?
    )
  end

  def detail : Credit
    Credit.detail(credit_id)
  end
end
