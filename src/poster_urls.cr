module Tmdb::PosterUrls
  # Get the poster full URL.
  #
  # By default `original` size is returned. See
  # `Tmdb::Configuration#images_poster_sizes` for more details.
  def poster_url(size : String = "original") : String
    unless poster_path.nil?
      String.build do |s|
        s << Tmdb.api.configuration.images_secure_base_url
        s << size
        s << poster_path.not_nil!
      end
    else
      ""
    end
  end
end
