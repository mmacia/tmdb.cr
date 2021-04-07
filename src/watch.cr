require "./provider"

class Tmdb::Watch
  property rent : Array(Provider) = [] of Provider
  property flatrate : Array(Provider) = [] of Provider
  property buy : Array(Provider) = [] of Provider
end
