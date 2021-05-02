require "./movie"

class Tmdb::MovieResult
  getter poster_path : String?
  getter? adult : Bool
  getter overview : String
  getter release_date : Time?
  getter genre_ids : Array(Int32)
  getter id : Int64
  getter original_title : String
  getter original_language : String
  getter title : String
  getter backdrop_path : String?
  getter popularity : Float64
  getter vote_count : Int32
  getter? video : Bool
  getter vote_average : Float64

  def initialize(data : JSON::Any)
    @poster_path = data["poster_path"]? ? data["poster_path"].as_s? : nil
    @adult = data["adult"].as_bool
    @overview = data["overview"].as_s

    date = data["release_date"]? ?  data["release_date"].as_s : ""
    @release_date = date.empty? ? nil : Time.parse(date,"%Y-%m-%d", Time::Location::UTC)

    @genre_ids = data["genre_ids"].as_a.map do |genre|
      genre.as_i
    rescue TypeCastError
      genre.as_f.to_i
    end

    @id = begin
            data["id"].as_i64
          rescue TypeCastError
            data["id"].as_f.to_i64
          end

    @original_title = data["original_title"].as_s
    @original_language = data["original_language"].as_s
    @title = data["title"].as_s
    @backdrop_path = data["backdrop_path"]? ? data["backdrop_path"].as_s? : nil
    @popularity = data["popularity"]? ? data["popularity"].as_f : 0.0

    @vote_count = begin
                    data["vote_count"].as_i
                  rescue TypeCastError
                    data["vote_count"].as_f.to_i
                  end

    @video = data["video"].as_bool

    begin
      vote_avg = data["vote_average"].as_f
    rescue TypeCastError
      vote_avg = data["vote_average"].as_i64.to_f64
    end

    @vote_average = vote_avg
  end

  def movie_detail(language : String? = nil) : Movie
    res = Resource.new("/movie/#{id}")
    Movie.detail(id, language)
  end
end
