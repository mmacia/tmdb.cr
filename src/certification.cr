class Tmdb::Certification
  # Certification name. Example PG-13, R, G, it depends on the country.
  getter certification : String
  # Certification description.
  getter meaning : String
  # Display order
  getter order : Int32

  # Get movie certifications
  #
  # Get an up to date list of the officially supported movie certifications on TMDB.
  # The results are grouped by country code.
  def self.movies : Hash(String, Array(Certification))
    res = Resource.new("/certification/movie/list")
    data = res.get

    ret = Hash(String, Array(Certification)).new

    data["certifications"].as_h.each do |country, certs|
      ret[country] = certs.as_a.map { |c| Certification.new(c) }
    end

    ret
  end

  # Get TV certifications
  #
  # Get an up to date list of the officially supported TV show certifications on TMDB.
  # The results are grouped by country code.
  def self.tv_shows : Hash(String, Array(Certification))
    res = Resource.new("/certification/tv/list")
    data = res.get

    ret = Hash(String, Array(Certification)).new

    data["certifications"].as_h.each do |country, certs|
      ret[country] = certs.as_a.map { |c| Certification.new(c) }
    end

    ret
  end

  def initialize(data : JSON::Any)
    @certification = data["certification"].as_s
    @meaning = data["meaning"].as_s
    @order = data["order"].as_i
  end
end
