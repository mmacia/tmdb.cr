class Tmdb::Image
  getter aspect_ratio : Float64
  getter file_path : String
  getter height : Int32
  getter iso_639_1 : String?
  getter vote_average : Float64
  getter vote_count : Int64
  getter width : Int32

  def initialize(data : JSON::Any)
    @aspect_ratio = data["aspect_ratio"].as_f
    @file_path = data["file_path"].as_s
    @height = data["height"].as_i
    @iso_639_1 = data["iso_639_1"]? ? data["iso_639_1"].as_s? : nil
    @vote_average = data["vote_average"].as_f
    @vote_count = data["vote_count"].as_i64
    @width = data["width"].as_i
  end

  def image_url(size : String = "original") : String
    String.build do |s|
      s << Tmdb.api.configuration.images_secure_base_url
      s << size
      s << file_path
    end
  end
end

class Tmdb::Backdrop < Tmdb::Image; end
class Tmdb::Poster < Tmdb::Image; end
class Tmdb::Profile < Tmdb::Image; end

class Tmdb::TaggedImage < Tmdb::Image
  getter media : MovieResult | Tv::ShowResult

  def initialize(data : JSON::Any)
    super(data)

    if data["media_type"].as_s == "movie"
      @media = MovieResult.new(data["media"])
    else
      @media = Tv::ShowResult.new(data["media"])
    end
  end
end
