require "./credit"

class Tmdb::CrewCredit
  getter original_name : String
  getter credit_id : String
  getter person : Person
  getter department : String
  getter job : String

  def initialize(data : JSON::Any)
    @original_name = data["original_name"].as_s
    @credit_id = data["credit_id"].as_s
    @department = data["department"].as_s
    @job = data["job"].as_s
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

  def credit_detail : Credit
    Credit.detail(credit_id)
  end
end
