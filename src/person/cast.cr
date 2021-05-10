require "./credit_base"

class Tmdb::Person
  class Cast < CreditBase
    getter character : String
    getter release_date : Time
    getter title : String

    def initialize(data : JSON::Any)
      super(data)

      @character = data["character"].as_s
      @release_date = Time.parse(data["release_date"].as_s, "%Y-%m-%d", Time::Location::UTC)
      @title = data["title"].as_s
      @genre_ids = data["genre_ids"].as_a.map(&.as_i)
      @popularity = data["popularity"].as_f
    end
  end
end
