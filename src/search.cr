require "./lazy_iterator"

class Tmdb::Search
  def self.movie(query : String, **filters) : LazyIterator(MovieResult)
    filters = filters.to_h.transform_values(&.to_s)
    filters.merge!({query: query}.to_h)

    res = Resource.new("/search/movie", filters)
    LazyIterator(MovieResult).new(res)
  end
end
