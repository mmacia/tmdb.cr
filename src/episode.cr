class Tmdb::Episode
  getter air_date : Time?
  getter episode_number : Int32
  getter name : String
  getter overview : String
  getter id : Int64
  getter production_code : String?
  getter season_number : Int32
  getter still_path : String?
  getter vote_average : Float64
  getter vote_count : Int32

  @crew : Array(Credit)? = nil
  @guest_stars : Array(Credit)? = nil

  def initialize(data : JSON::Any)
    date = data["air_date"].as_s?
    @air_date = date.nil? ? nil : Time.parse(date, "%Y-%m-%d", Time::Location::UTC)

    if data["crew"]?
      @crew = data["crew"].as_a.map do |crew|
        Credit.new(crew)
      end
    end

    @episode_number = data["episode_number"].as_i

    if data["guest_stars"]?
      @guest_stars = data["guest_stars"].as_a.map do |guest_star|
        Credit.new(guest_star)
      end
    end

    @name = data["name"].as_s
    @overview = data["overview"].as_s
    @id = data["id"].as_i64
    @production_code = data["production_code"].as_s?
    @season_number = data["season_number"].as_i
    @still_path = data["still_path"].as_s?
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i
  end

  def crew : Array(Credit)
    refresh! if @crew.nil?
    @crew.not_nil!
  end

  def guest_star : Array(Credit)
    refresh! if @guest_star.nil?
    @guest_star.not_nil!
  end

  private def refresh!
  end
end
