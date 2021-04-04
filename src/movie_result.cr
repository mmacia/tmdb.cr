class Tmdb::MovieResult
  getter poster_path : String?
  getter? adult : Bool
  getter overview : String
  getter release_date : Time
  getter genre_ids : Array(Int32)
  getter id : Int32
  getter original_title : String
  original_language string
  title string
  backdrop_path string or null
  popularity number
  vote_count integer
  video boolean
  vote_average

  def initialize(data : JSON::Any)
  end
end
