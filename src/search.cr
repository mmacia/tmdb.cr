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
    filters = FilterFactory.create_language(language)
    filters[:query] = query
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:region] = region.not_nil!.upcase unless region.nil?
    filters[:year] = year.not_nil!.to_s unless year.nil?
    filters[:primary_release_year] = primary_release_year.not_nil!.to_s unless primary_release_year.nil?

    res = Resource.new("/search/movie", filters)
    LazyIterator(MovieResult).new(res)
  end

  def self.companies(query : String) : LazyIterator(CompanyResult)
    res = Resource.new("/search/company", FilterFactory.create(query: query))
    LazyIterator(CompanyResult).new(res)
  end

  def self.collections(query : String, language : String? = nil) : LazyIterator(CollectionResult)
    filters = FilterFactory.create_language(language)
    filters[:query] = query

    res = Resource.new("/search/collection", filters)
    LazyIterator(CollectionResult).new(res)
  end

  def self.keywords(query : String) : LazyIterator(Keyword)
    res = Resource.new("/search/keyword", FilterFactory.create(query: query))
    LazyIterator(Keyword).new(res)
  end

  def self.people(
    query : String,
    language : String? = nil,
    include_adult : Bool? = nil,
    region : String? = nil
  ) : LazyIterator(PersonResult)
    filters = FilterFactory.create_language(language)
    filters[:query] = query
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:region] = region.not_nil!.upcase unless region.nil?

    res = Resource.new("/search/person", filters)
    LazyIterator(PersonResult).new(res)
  end

  def self.tv_shows(
    query : String,
    language : String? = nil,
    include_adult : Bool? = nil,
    first_air_date_year : Int32? = nil
  ) : LazyIterator(Tv::ShowResult)
    filters = FilterFactory.create_language(language)
    filters[:query] = query
    filters[:include_adult] = include_adult.not_nil!.to_s unless include_adult.nil?
    filters[:first_air_date_year] = first_air_date_year.not_nil!.to_s unless first_air_date_year.nil?

    res = Resource.new("/search/tv", filters)
    LazyIterator(Tv::ShowResult).new(res)
  end
end
