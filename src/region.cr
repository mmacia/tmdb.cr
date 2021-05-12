class Tmdb::Region
  getter iso_3166_1 : String
  getter english_name : String
  getter native_name : String

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s
    @english_name = data["english_name"].as_s
    @native_name = data["native_name"].as_s
  end
end
