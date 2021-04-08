class Tmdb::Country
  getter iso_3166_1 : String
  getter name : String

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s

    @name = ""
    @name = data["name"].as_s if data["name"]?
    @name = data["english_name"].as_s if data["english_name"]?
  end

  def code : String
    iso_3166_1
  end
end
