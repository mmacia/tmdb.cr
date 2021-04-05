class Tmdb::Country
  getter iso_3166_1 : String
  getter name : String

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s
    @name = data["name"].as_s
  end

  def code : String
    iso_3166_1
  end
end
