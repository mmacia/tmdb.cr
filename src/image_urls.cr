require "./poster_urls"

module Tmdb::ImageUrls
  include PosterUrls

  # Get the backdrop full URL.
  #
  # By default `original` size is returned. See
  # `Tmdb::Configuration#images_backdrop_sizes` for more details.
  def backdrop_url(size : String = "original") : String
    unless backdrop_path.nil?
      String.build do |s|
        s << Tmdb.api.configuration.images_secure_base_url
        s << size
        s << backdrop_path.not_nil!
      end
    else
      ""
    end
  end
end
