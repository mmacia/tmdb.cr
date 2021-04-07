class Tmdb::Release
  enum Type
    Unknown
    Premiere
    TheatricalLimited
    Theatrical
    Digital
    Physical
    TV
  end

  getter certification : String
  getter iso_639_1 : String?
  getter release_date : Time
  getter type : Type
  getter note : String

  def initialize(data : JSON::Any)
    @certification = data["certification"].as_s
    @iso_639_1 = data["iso_639_1"].as_s?
    @release_date = Time.parse(data["release_date"].as_s, "%Y-%m-%d", Time::Location::UTC)
    @type = Type.from_value(data["type"].as_i)
    @note = data["note"].as_s
  end
end
