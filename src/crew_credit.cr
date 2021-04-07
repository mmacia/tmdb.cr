class Tmdb::CastCredit < Tmdb::Credit
  getter original_name : String
  getter credit_id : String
  getter person : Person
  getter cast_id : Int32
  getter character : String
  getter order : Int32

  def initialize(data : JSON::Any)
    @cast_id = data["cast_id"].as_i
    @character = data["character"].as_s
    @order = data["order"].as_i
    @original_name = data["original_name"].as_s
    @credit_id = data["credit_id"].as_s
    @person = Person.new(data, full_initialized: false)
  end
end
