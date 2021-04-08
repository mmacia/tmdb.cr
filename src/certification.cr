class Tmdb::Certification
  getter certification : String
  getter meaning : String
  getter order : Int32

  def self.movies : Hash(String, Array(Certification))
    res = Resource.new("/certification/movie/list")
    data = res.get

    ret = Hash(String, Array(Certification)).new

    data["certifications"].as_h.each do |country, certs|
      ret[country] = certs.as_a.map { |c| Certification.new(c) }
    end

    ret
  end

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
