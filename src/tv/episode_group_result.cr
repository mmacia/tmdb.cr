require "../network"

class Tmdb::Tv::EpisodeGroupResult
  enum Type
    Unknown
    OriginalAirDate
    Absolute
    DVD
    Digital
    StoryArc
    Production
    TV
  end

  getter description : String
  getter episode_count : Int32
  getter group_count : Int32
  getter id : String
  getter name : String
  getter network : Network
  getter type : Type

  def initialize(data : JSON::Any)
    @description = data["description"].as_s
    @episode_count = data["episode_count"].as_i
    @group_count = data["group_count"].as_i
    @id = data["id"].as_s
    @name = data["name"].as_s
    @network = Network.new(data["network"])
    @type = Type.from_value(data["type"].as_i)
  end
end
