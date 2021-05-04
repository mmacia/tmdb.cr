module Tmdb::ProfileUrls
  # Get the profile full URL.
  #
  # By default `original` size is returned. See
  # `Tmdb::Configuration#images_profile_sizes` for more details.
  def profile_url(size : String = "original") : String
    unless profile_path.nil?
      String.build do |s|
        s << Tmdb.api.configuration.images_secure_base_url
        s << size
        s << profile_path.not_nil!
      end
    else
      ""
    end
  end
end
