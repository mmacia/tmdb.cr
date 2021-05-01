class Tmdb::Configuration
  getter images_base_url : String
  getter images_secure_base_url : String
  getter images_backdrop_sizes : Array(String)
  getter images_logo_sizes : Array(String)
  getter images_poster_sizes : Array(String)
  getter images_profile_sizes : Array(String)
  getter images_still_sizes : Array(String)
  getter change_keys : Array(String)

  # Get the system wide configuration information. Some elements of the API
  # require some knowledge of this configuration data. The purpose of this is
  # to try and keep the actual API responses as light as possible. It is
  # recommended you cache this data within your application and check for
  # updates every few days.
  #
  # This method currently holds the data relevant to building image URLs as
  # well as the change key map.
  #
  # To build an image URL, you will need 3 pieces of data. The `base_url`,
  # `size` and `file_path`. Simply combine them all and you will have a fully
  # qualified URL. Here’s an example URL:
  #
  # ```
  # https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg
  # ```
  # The configuration method also contains the list of change keys which can be
  # useful if you are building an app that consumes data from the change feed.
  def self.detail : Configuration
    res = Resource.new("/configuration")
    Configuration.new(res.get)
  end

  # Get the list of countries (ISO 3166-1 tags) used throughout TMDB.
  def self.countries : Array(Country)
    res = Resource.new("/configuration/countries")
    res.get.as_a.map { |c| Country.new(c) }
  end

  # Get a list of the jobs and departments we use on TMDB.
  def self.jobs : Hash(String, Array(String))
    res = Resource.new("/configuration/jobs")
    ret = Hash(String, Array(String)).new

    res.get.as_a.each do |item|
      ret[item["department"].as_s] = item["jobs"].as_a.map(&.to_s)
    end

    ret
  end

  # Get the list of languages (ISO 639-1 tags) used throughout TMDB.
  def self.languages : Array(Language)
    res = Resource.new("/configuration/languages")
    res.get.as_a.map { |l| Language.new(l) }
  end

  # Get a list of the *officially* supported translations on TMDB.
  #
  # While it's technically possible to add a translation in any one of the
  # `#languages` we have added to TMDB (we don't restrict content), the ones
  # listed in this method are the ones we also support for localizing the
  # website with which means they are what we refer to as the "primary"
  # translations.
  #
  # These are all specified as [IETF tags](https://en.wikipedia.org/wiki/IETF_language_tag)
  # to identify the languages we use on TMDB. There is one exception which is
  # image languages. They are currently only designated by a ISO-639-1 tag.
  # This is a planned upgrade for the future.
  #
  # We're always open to adding more if you think one should be added. You can
  # ask about getting a new primary translation added by posting on
  # [the forums](https://www.themoviedb.org/talk/category/5047951f760ee3318900009a).
  #
  # One more thing to mention, these are the translations that map to our
  # website translation project. You can view and contribute to that project
  # [here](https://app.localeapp.com/projects/8267).
  def self.primary_translations : Array(String)
    res = Resource.new("/configuration/primary_translations")
    res.get.as_a.map(&.to_s)
  end

  # Get the list of timezones used throughout TMDB.
  def self.timezones : Hash(String, Array(String))
    res = Resource.new("/configuration/timezones")
    ret = Hash(String, Array(String)).new

    res.get.as_a.each do |item|
      ret[item["iso_3166_1"].as_s] = item["zones"].as_a.map(&.to_s)
    end

    ret
  end

  def initialize(data : JSON::Any)
    @images_base_url = data["images"]["base_url"].as_s
    @images_secure_base_url = data["images"]["secure_base_url"].as_s
    @images_backdrop_sizes = data["images"]["backdrop_sizes"].as_a.map(&.to_s)
    @images_logo_sizes = data["images"]["logo_sizes"].as_a.map(&.to_s)
    @images_poster_sizes = data["images"]["poster_sizes"].as_a.map(&.to_s)
    @images_profile_sizes = data["images"]["profile_sizes"].as_a.map(&.to_s)
    @images_still_sizes = data["images"]["still_sizes"].as_a.map(&.to_s)
    @change_keys = data["change_keys"].as_a.map(&.to_s)
  end
end
