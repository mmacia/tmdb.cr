require "../network"

class Tmdb::Tv::EpisodeGroup
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

  class Group
    getter id : String
    getter name : String
    getter order : Int32
    getter episodes : Array(Episode)
    getter locked : Bool

    def initialize(data : JSON::Any)
      @id = data["id"].as_s
      @name = data["name"].as_s
      @order = data["order"].as_i
      @locked = data["locked"].as_bool

      show_id = data["episodes"].as_a.first["show_id"].as_i64
      @episodes = data["episodes"].as_a.map { |episode| Episode.new(episode, show_id) }
    end
  end

  getter description : String
  getter episode_count : Int32
  getter group_count : Int32
  getter groups : Array(Group)
  getter id : String
  getter name : String
  getter network : Network
  getter type : Type

  # Get the details of a TV episode group.
  def self.detail(id : String, language : String? = nil) : EpisodeGroup
    res = Resource.new("/tv/episode_group/#{id}", FilterFactory.create_language(language))
    EpisodeGroup.new(res.get)
  end

  def initialize(data : JSON::Any)
    @description = data["description"].as_s
    @episode_count = data["episode_count"].as_i
    @group_count = data["group_count"].as_i
    @groups = data["groups"].as_a.map { |group| Group.new(group) }
    @id = data["id"].as_s
    @name = data["name"].as_s
    @network = Network.new(data["network"])
    @type = Type.from_value(data["type"].as_i)
  end
end
