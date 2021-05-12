class Tmdb::Change
  class Item
    getter id : String
    getter action : String
    getter time : Time
    getter iso_639_1 : String?
    getter value : String
    getter original_value : String?

    def initialize(data : JSON::Any)
      @id = data["id"].as_s
      @action = data["action"].as_s
      @time = Time.parse(data["time"].as_s, "%Y-%m-%d %H:%M:%s", Time::Location::UTC)
      @iso_639_1 = data["iso_639_1"]? ? data["iso_639_1"].as_s : nil
      @value = data["value"].to_json

      if data["original_value"]?
        @original_value = data["original_value"].to_json
      else
        @original_value = nil
      end
    end
  end
end
