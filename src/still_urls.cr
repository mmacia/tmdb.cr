module Tmdb::StillUrls
  # Get the still full URL.
  #
  # By default `original` size is returned. See
  # `Tmdb::Configuration#images_still_sizes` for more details.
  def still_url(size : String = "original") : String
    unless still_path.nil?
      String.build do |s|
        s << Tmdb.api.configuration.images_secure_base_url
        s << size
        s << still_path.not_nil!
      end
    else
      ""
    end
  end
end
