require "../person"
require "./cast_base"

class Tmdb::Tv::AggregatedCast < Tmdb::Tv::CastBase
  class Role
    getter credit_id : String
    getter character : String
    getter episode_count : Int32

    def initialize(data : JSON::Any)
      @credit_id = data["credit_id"].as_s
      @character = data["character"].as_s
      @episode_count = data["episode_count"].as_i
    end
  end

  getter roles : Array(Role)
  getter total_episode_count : Int32

  def initialize(data : JSON::Any)
    super(data)

    @roles = data["roles"].as_a.map { |role| Role.new(role) }
    @total_episode_count = data["total_episode_count"].as_i
  end
end
