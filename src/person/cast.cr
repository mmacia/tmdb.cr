require "./credit_base"

class Tmdb::Person
  class Cast < CreditBase
    getter character : String

    def initialize(data : JSON::Any)
      super(data)

      @character = data["character"].as_s
    end
  end
end
