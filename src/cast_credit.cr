class Tmdb::CrewCredit < Tmdb::Credit
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
    @person = Person.new(data, full_initialized: false)
  end
end
