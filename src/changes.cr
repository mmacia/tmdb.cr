class Tmdb::Changes
  class Change
    getter id : Int64
    getter? adult : Bool?

    def initialize(data : JSON::Any)
      @id = data["id"].as_i64
      @adult = data["adult"].as_bool?
    end
  end

  # Get a list of all of the movie ids that have been changed in the past 24
  # hours.
  #
  # You can query it for up to 14 days worth of changed IDs at a time with the
  # `start_date` and `end_date` query parameters.
  def self.movie(start_date : Time? = nil, end_date : Time? = nil, skip_cache : Bool = false) : LazyIterator(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/movie/changes", filters)
    LazyIterator(Change).new(res, skip_cache: skip_cache)
  end

  # Get a list of all of the TV show ids that have been changed in the past 24
  # hours.
  #
  # You can query it for up to 14 days worth of changed IDs at a time with the
  # `start_date` and `end_date` query parameters.
  def self.tv_show(start_date : Time? = nil, end_date : Time? = nil, skip_cache : Bool = false) : LazyIterator(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/tv/changes", filters)
    LazyIterator(Change).new(res, skip_cache: skip_cache)
  end

  # Get a list of all of the people ids that have been changed in the past 24
  # hours.
  #
  # You can query it for up to 14 days worth of changed IDs at a time with the
  # `start_date` and `end_date` query parameters.
  def self.person(start_date : Time? = nil, end_date : Time? = nil, skip_cache : Bool = false) : LazyIterator(Change)
    filters = FilterFactory::Filter.new
    filters[:start_date] = start_date.to_s("%Y-%m-%d") unless start_date.nil?
    filters[:end_date] = end_date.to_s("%Y-%m-%d") unless end_date.nil?

    res = Resource.new("/person/changes", filters)
    LazyIterator(Change).new(res, skip_cache: skip_cache)
  end
end
