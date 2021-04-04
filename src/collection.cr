class Tmdb::Collection
  class Part
    getter? adult : Bool
    getter backdrop_path : String
    getter genre_ids : Array(Int32)
    getter id : Int32
    getter original_language : String
    getter original_title : String
    getter overview : String
    getter release_date : Time
    getter poster_path : String
    getter popularity : Float64
    getter title : String
    getter? video : Bool
    getter vote_average : Float64
    getter vote_count : Int32

    def initialize(data : JSON::Any)
      @adult = data["adult"].as_bool
      @backdrop_path = data["backdrop_path"].as_s
      @genre_ids = data["genre_ids"].as_a.map(&.as_i)
      @id = data["id"].as_i
      @original_language = data["original_language"].as_s
      @original_title = data["original_title"].as_s
      @overview = data["overview"].as_s

      date = data["release_date"].as_s
      @release_date = Time.parse(date, "%Y-%m-%d", Time::Location::UTC)
      @poster_path = data["poster_path"].as_s
      @popularity = data["popularity"].as_f
      @title = data["title"].as_s
      @video = data["video"].as_bool
      @vote_average = data["vote_average"].as_f
      @vote_count = data["vote_count"].as_i
    end

    def movie_detail(**filters) : Movie
      filters = filters.to_h.transform_values(&.to_s)
      res = Resource.new("/movie/#{id}", filters)
      Movie.new(res.get)
    end

    def movie_detail : Movie
      res = Resource.new("/movie/#{id}")
      Movie.new(res.get)
    end
  end

  getter id : Int64
  getter name : String
  getter poster_path : String
  getter backdrop_path : String
  @overview : String? = nil
  @parts : Array(Part) = [] of Part

  private getter? full_initialized : Bool


  def initialize(@id, @name, @poster_path, @backdrop_path)
    @full_initialized = false
  end

  def initialize(data : JSON::Any)
    @id = data["id"].as_i64
    @name = data["name"].as_s
    @overview = data["overview"].as_s
    @poster_path = data["poster_path"].as_s
    @backdrop_path = data["backdrop_path"].as_s

    @parts = data["parts"].as_a.map do |part|
      Part.new(part)
    end
    @full_initialized = true
  end

  def parts : Array(Part)
    refresh! unless full_initialized?
    @parts
  end

  def overview : String
    refresh! unless full_initialized?
    @overview.not_nil!
  end

  private def refresh!
    res = Resource.new("/collection/#{id}")
    data = res.get

    @id = data["id"].as_i64
    @name = data["name"].as_s
    @overview = data["overview"].as_s
    @poster_path = data["poster_path"].as_s
    @backdrop_path = data["backdrop_path"].as_s

    @parts = data["parts"].as_a.map do |part|
      Part.new(part)
    end

    @full_initialized = true
  end
end
