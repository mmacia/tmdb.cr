require "./credit_base"

class Tmdb::Person
  class Crew < CreditBase
    getter department : String
    getter job : String

    def initialize(data : JSON::Any)
      super(data)

      @department = data["department"].as_s
      @job = data["job"].as_s
    end
  end
end
