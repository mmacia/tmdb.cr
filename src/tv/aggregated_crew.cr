require "./crew_base"

class Tmdb::Tv::AggregatedCrew < Tmdb::Tv::CrewBase
  class Job
    getter credit_id : String
    getter job : String
    getter episode_count : Int32?

    def initialize(data : JSON::Any)
      @credit_id = data["credit_id"].as_s
      @job = data["job"].as_s
      @episode_count = data["episode_count"]? ? data["episode_count"].as_i : nil
    end
  end

  getter jobs : Array(Job)
  getter total_episode_count : Int32

  def initialize(data : JSON::Any)
    super(data)

    @jobs = data["jobs"].as_a.map { |job| Job.new(job) }
    @total_episode_count = data["total_episode_count"].as_i
  end
end
