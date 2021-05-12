require "./change_item"

class Tmdb::Change
  getter key : String
  getter items : Array(Item)

  def initialize(data : JSON::Any)
    @key = data["key"].as_s
    @items = data["items"].as_a.map { |item| Item.new(item) }
  end
end
