require "./person"
require "./media_type"

class Tmdb::Credit
  enum Type
    Cast
    Crew
    Creator
  end

  class Media
    getter media_type : ::Tmdb::Media::Type
    getter media : MovieResult | Tv::ShowResult
    getter character : String?

    def initialize(@media_type : ::Tmdb::Media::Type, data : JSON::Any)
      if media_type.tv?
        @media = Tv::ShowResult.new(data)
      else
        @media = MovieResult.new(data)
      end

      @character = data["character"]? ? data["character"].as_s : nil
    end
  end

  getter credit_type : Type
  getter department : String
  getter job : String
  getter media : Media
  getter id : String
  getter person : Person

  def self.detail(id : String) : Credit
    res = Resource.new("/credit/#{id}")
    Credit.new(res.get)
  end

  def initialize(data : JSON::Any)
    @credit_type = Type.parse(data["credit_type"].as_s)
    @department = data["department"].as_s
    @job = data["job"].as_s
    @media = Media.new(::Tmdb::Media::Type.parse(data["media_type"].as_s), data["media"])
    @id = data["id"].as_s
    @person = Person.new(
      name: data["person"]["name"].as_s,
      id: data["person"]["id"].as_i64,
    )
  end
end
