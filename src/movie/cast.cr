require "./credit_base"

class Tmdb::Movie
  class Cast < CreditBase
    getter cast_id : Int32?
    getter character : String?
    getter order : Int32

    def initialize(data : JSON::Any)
      super(data)

      @cast_id = data["cast_id"].as_i

      chr = data["character"].as_s?
      character = if chr.nil?
                    nil
                  else
                    chr.not_nil!.empty? ? nil : chr.not_nil!
                  end

      @character = character
      @order = data["order"].as_i
    end
  end
end
