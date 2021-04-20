class Tmdb::Tv::Rating
  getter iso_3166_1 : String
  getter rating : String

  def initialize(data : JSON::Any)
    @iso_3166_1 = data["iso_3166_1"].as_s
    @rating = data["rating"].as_s
  end
end
