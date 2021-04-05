class Tmdb::Language
  getter iso_639_1 : String
  getter name : String

  def initialize(data : JSON::Any)
    @iso_639_1 = data["iso_639_1"].as_s
    @name = data["name"].as_s
  end

  def code : String
    iso_639_1
  end
end
