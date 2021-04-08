require "./lazy_iterator"
require "./movie_result"
require "./company_result"
require "./collection_result"
require "./keyword"
require "./person_result"

class Tmdb::Search
  def self.movies(
    query : String,
    language : String? = nil,
    include_adult : Bool? = nil,
    region : String? = nil,
    year : Int32? = nil,
    primary_release_year : Int32? = nil
  ) : LazyIterator(MovieResult)
    filters = Hash(Symbol, String).new
    filters[:query] = query
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:region] = region.not_nil!.upcase unless region.nil?
    filters[:year] = year.not_nil!.to_s unless year.nil?
    filters[:primary_release_year] = primary_release_year.not_nil!.to_s unless primary_release_year.nil?

    res = Resource.new("/search/movie", filters)
    LazyIterator(MovieResult).new(res)
  end

  def self.companies(query : String) : LazyIterator(CompanyResult)
    filters = Hash(Symbol, String).new
    filters[:query] = query

    res = Resource.new("/search/company", filters)
    LazyIterator(CompanyResult).new(res)
  end

  def self.collections(query : String, language : String? = nil) : LazyIterator(CollectionResult)
    filters = Hash(Symbol, String).new
    filters[:query] = query
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    res = Resource.new("/search/collection", filters)
    LazyIterator(CollectionResult).new(res)
  end

  def self.keywords(query : String) : LazyIterator(Keyword)
    filters = Hash(Symbol, String).new
    filters[:query] = query

    res = Resource.new("/search/keyword", filters)
    LazyIterator(Keyword).new(res)
  end

  def self.people(
    query : String,
    language : String? = nil,
    include_adult : Bool? = nil,
    region : String? = nil
  ) : LazyIterator(PersonResult)
    filters = Hash(Symbol, String).new
    filters[:query] = query
    filters[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:region] = region.not_nil!.upcase unless region.nil?

    res = Resource.new("/search/person", filters)
    LazyIterator(PersonResult).new(res)
  end

  def self.tv_shows()
    # Implement me
  end
end
