class Tmdb::Configuration
  getter images_base_url : String
  getter images_secure_base_url : String
  getter images_backdrop_sizes : Array(String)
  getter images_logo_sizes : Array(String)
  getter images_poster_sizes : Array(String)
  getter images_profile_sizes : Array(String)
  getter images_still_sizes : Array(String)
  getter change_keys : Array(String)

  def self.detail : Configuration
    res = Resource.new("/configuration")
    Configuration.new(res.get)
  end

  def self.countries : Array(Country)
    res = Resource.new("/configuration/countries")
    data = res.get

    data.as_a.map { |c| Country.new(c) }
  end

  def self.jobs : Hash(String, Array(String))
    res = Resource.new("/configuration/jobs")
    data = res.get

    ret = Hash(String, Array(String)).new

    data.as_a.each do |item|
      ret[item["department"].as_s] = item["jobs"].as_a.map(&.to_s)
    end

    ret
  end

  def self.languages : Array(Language)
    res = Resource.new("/configuration/languages")
    data = res.get

    data.as_a.map { |l| Language.new(l) }
  end

  def self.primary_translations : Array(String)
    res = Resource.new("/configuration/primary_translations")
    data = res.get

    data.as_a.map(&.to_s)
  end

  def self.timezones : Hash(String, Array(String))
    res = Resource.new("/configuration/timezones")
    data = res.get

    ret = Hash(String, Array(String)).new

    data.as_a.each do |item|
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
