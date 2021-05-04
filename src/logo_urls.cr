module Tmdb::LogoUrls
  # Get the logo full URL.
  #
  # By default `original` size is returned. See
  # `Tmdb::Configuration#images_logo_sizes` for more details.
  def logo_url(size : String = "original") : String
    unless logo_path.nil?
      String.build do |s|
        s << Tmdb.api.configuration.images_secure_base_url
        s << size
        s << logo_path.not_nil!
      end
    else
      ""
    end
  end
end
