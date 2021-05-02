class Tmdb::Find
  enum ExternalSource
    Imdb
    Tvdb
    Facebook
    Instagram
    Twitter

    def to_s : String
      case super.to_s
      when "Imdb"
        "imdb_id"
      when "Tvdb"
        "tvdb_id"
      when "Facebook"
        "facebook_id"
      when "Instagram"
        "instagram_id"
      when "Twitter"
        "twitter_id"
      else
        raise RuntimeError.new
      end
    end
  end

  # The find method makes it easy to search for objects in our database by an
  # external id.
  #
  # This method will search all objects (movies, TV shows and people) and
  # return the results in a single response.
  #
  # The supported external sources for each object are as follows.
  #
  # * IMDb
  # * TVDb
  # * Facebook
  # * Instagram
  # * Twitter
  def self.find(
    external_id : String,
    external_source : ExternalSource,
    language : String? = nil
  ) : Array(MovieResult | Tv::ShowResult | PersonResult)
    filters = FilterFactory.create_language(language)
    filters[:external_source] = external_source.to_s

    res = Resource.new("/find/#{external_id}", filters)
    data = res.get
    ret = [] of MovieResult | Tv::ShowResult | PersonResult

    data["movie_results"].as_a.reduce(ret) { |ret, movie| ret << MovieResult.new(movie) }
    data["person_results"].as_a.reduce(ret) { |ret, person| ret << PersonResult.new(person) }
    data["tv_results"].as_a.reduce(ret) { |ret, tv_show| ret << Tv::ShowResult.new(tv_show) }

    ret
  end

  # See `#find`
  def self.find_movie(
    external_id : String,
    external_source : ExternalSource,
    language : String? = nil
  ) : Array(MovieResult)
    find(external_id, external_source, language).select(MovieResult)
  end

  # See `#find`
  def self.find_tv_show(
    external_id : String,
    external_source : ExternalSource,
    language : String? = nil
  ) : Array(Tv::ShowResult)
    find(external_id, external_source, language).select(Tv::ShowResult)
  end

  # See `#find`
  def self.find_person(
    external_id : String,
    external_source : ExternalSource,
    language : String? = nil
  ) : Array(PersonResult)
    find(external_id, external_source, language).select(PersonResult)
  end
end
