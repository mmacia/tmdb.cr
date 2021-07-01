class Tmdb::Discover
  class QueryBuilder
    enum SortType
      PopularityAsc
      PopularityDesc
      ReleaseDateAsc
      ReleaseDateDesc
      RevenueAsc
      RevenueDesc
      PrimaryReleaseDateAsc
      PrimaryReleaseDateDesc
      OriginalTitleAsc
      OriginalTitleDesc
      VoteAverageAsc
      VoteAverageDesc
      VoteCountAsc
      VoteCountDesc

      def to_s : String
        case super.to_s
        when "PopularityAsc"
          "popularity.asc"
        when "PopularityDesc"
          "popularity.desc"
        when "ReleaseDateDesc"
          "release_date.desc"
        when "ReleaseDateAsc"
          "release_date.asc"
        when "RevenueAsc"
          "revenue.asc"
        when "RevenueDesc"
          "revenue.desc"
        when "PrimaryReleaseDateAsc"
          "primary_release_date.asc"
        when "PrimaryReleaseDateDesc"
          "primary_release_date.desc"
        when "OriginalTitleAsc"
          "original_title.asc"
        when "OriginalTitleDesc"
          "original_title.desc"
        when "VoteAverageAsc"
          "vote_average.asc"
        when "VoteAverageDesc"
          "vote_average.desc"
        when "VoteCountAsc"
          "vote_count.asc"
        when "VoteCountDesc"
          "vote_count.desc"
        else
          raise RuntimeError.new
        end
      end
    end

    enum MonetizationType
      Flatrate
      Free
      Ads
      Rent
      Buy

      def to_s : String
        super.to_s.downcase
      end
    end

    @language : String? = nil
    @region : String? = nil
    @sort_by : SortType? = nil
    @certification_country : String? = nil
    @certification : String? = nil
    @certification_lte : String? = nil
    @certification_gte : String? = nil
    @include_adult : Bool? = nil
    @include_video : Bool? = nil
    @primary_release_year : Int32? = nil
    @primary_release_date_gte : Time? = nil
    @primary_release_date_lte : Time? = nil
    @release_date_gte : Time? = nil
    @release_date_lte : Time? = nil
    @with_release_type : Int32? = nil
    @year : Int32? = nil
    @vote_count_lte : Int64? = nil
    @vote_count_gte : Int64? = nil
    @vote_average_gte : Float64? = nil
    @vote_average_lte : Float64? = nil
    @with_cast : Array(Int64)? = nil
    @with_crew : Array(Int64)? = nil
    @with_people : Array(Int64)? = nil
    @with_companies : Array(Int32)? = nil
    @with_genres : Array(Int32)? = nil
    @without_genres : Array(Int32)? = nil
    @with_keywords : Array(String)? = nil
    @without_keywords : Array(String)? = nil
    @with_runtime_gte : Int32? = nil
    @with_runtime_lte : Int32? = nil
    @with_original_language : String? = nil
    @with_watch_providers : Array(String)? = nil
    @watch_region : String? = nil
    @with_watch_monetization_types : MonetizationType? = nil

    # TV shows attributes
    @air_date_gte : Time? = nil
    @air_date_lte : Time? = nil
    @first_air_date_gte : Time? = nil
    @first_air_date_lte : Time? = nil
    @first_air_date_year : Int32? = nil
    @timezone : String? = nil
    @with_networks : Array(String)? = nil
    @include_null_first_air_dates : Bool? = nil
    @screened_theatrically : Bool? = nil

    # Filter and only include TV shows that have a air date (by looking at all
    # episodes) that is greater or equal to the specified value.
    def air_date_gte(@air_date_gte : Time)
      self
    end

    # Filter and only include TV shows that have a air date (by looking at all
    # episodes) that is less than or equal to the specified value.
    def air_date_lte(@air_date_lte : Time)
      self
    end

    # Filter and only include TV shows that have a original air date that is
    # greater or equal to the specified value. Can be used in conjunction with
    # the `include_null_first_air_dates` filter if you want to include items
    # with no air date.
    def first_air_date_gte(@first_air_date_gte : Time)
      self
    end

    # Filter and only include TV shows that have a original air date that is
    # less or equal to the specified value. Can be used in conjunction with
    # the `include_null_first_air_dates` filter if you want to include items
    # with no air date.
    def first_air_date_lte(@first_air_date_lte : Time)
      self
    end

    # Filter and only include TV shows that have a original air date year that
    # equal to the specified value. Can be used in conjunction with the
    # `include_null_first_air_dates` filter if you want to include items with
    # no air date.
    def first_air_date_year(@first_air_date_year : Int32)
      self
    end

    # Comma separated value of network ids that you want to include in the
    # results.
    def with_networks(network : String)
      @with_networks = [] of String if @with_networks.nil?
      @with_networks.not_nil! << network
      self
    end

    def with_networks(networks : Array(String))
      @with_networks = [] of String if @with_networks.nil?
      @with_networks = @with_networks.not_nil! + networks
      self
    end

    # Use this filter to include TV shows that don't have an air date while
    # using any of the `first_air_date` filters.
    def include_null_first_air_dates(@include_null_first_air_dates : Bool)
      self
    end

    # Filter results to include items that have been screened theatrically.
    def screened_theatrically(@screened_theatrically : Bool)
      self
    end

    # Used in conjunction with the `air_date.gte/lte` filter to calculate the
    # proper UTC offset.
    #
    # default: America/New_York
    def timezone(@timezone : String)
      self
    end

    # Specify a language to query translatable fields with.
    def language(@language : String)
      self
    end

    # Specify a ISO 3166-1 code to filter release dates.
    def region(value : String)
      @region = value.upcase
      self
    end

    # Sort option.
    def sort_by(@sort_by : SortType)
      self
    end

    # Used in conjunction with the `#certification` filter, use this to specify
    # a country with a valid certification.
    def certification_country(certification_country : String)
      @certification_country = certification_country.upcase
      self
    end

    # Filter results with a valid certification from the
    # '#certification_country' field.
    def certification(@certification : String)
      self
    end

    # Filter and only include movies that have a certification that is less
    # than or equal to the specified value.
    def certification_lte(@certification_lte : String)
      self
    end

    # Filter and only include movies that have a certification that is greater
    # than or equal to the specified value.
    def certification_gte(@certification_gte : String)
      self
    end

    # A filter and include or exclude adult movies.
    def include_adult(@include_adult : Bool)
      self
    end

    # A filter to include or exclude videos.
    def include_video(@include_video : Bool)
      self
    end

    # A filter to limit the results to a specific primary release year.
    def primary_release_year(@primary_release_year : Int32)
      self
    end

    # Filter and only include movies that have a primary release date that is
    # greater or equal to the specified value.
    def primary_release_date_gte(@primary_release_date_gte : Time)
      self
    end

    # Filter and only include movies that have a primary release date that is
    # less or equal to the specified value.
    def primary_release_date_lte(@primary_release_date_lte : Time)
      self
    end

    # Filter and only include movies that have a release date that is
    # greater or equal to the specified value.
    def release_date_gte(@release_date_gte : Time)
      self
    end

    # Filter and only include movies that have a release date that is
    # less or equal to the specified value.
    def release_date_lte(@release_date_lte : Time)
      self
    end

    # Specify a comma (AND) or pipe (OR) separated value to filter release
    # types by. These release types map to the same values found on the movie
    # release date method.
    def with_release_type(@with_release_type : Int32)
      self
    end

    # A filter to limit the results to a specific year (looking at all release
    # dates).
    def year(@year : Int32)
      self
    end

    # Filter and only include movies that have a vote count that is greater or
    # equal to the specified value.
    def vote_count_gte(@vote_count_gte : Int64)
      self
    end

    # Filter and only include movies that have a vote count that is less or
    # equal to the specified value.
    def vote_count_lte(@vote_count_lte : Int64)
      self
    end

    # Filter and only include movies that have a rating count that is greater or
    # equal to the specified value.
    def vote_average_gte(@vote_average_gte : Float64)
      self
    end

    # Filter and only include movies that have a rating count that is greater or
    # equal to the specified value.
    def vote_average_gte(@vote_average_gte : Float64)
      self
    end

    # A comma separated list of person ID's. Only include movies that have one
    # of the ID's added as an actor.
    def with_cast(cast : Int64)
      @with_cast = [] of Int64 if @with_cast.nil?
      @with_cast.not_nil! << cast
      self
    end

    def with_cast(cast : Array(Int64))
      @with_cast = [] of Int64 if @with_cast.nil?
      @with_cast = @with_cast.not_nil! + cast
      self
    end

    # A comma separated list of person ID's. Only include movies that have one
    # of the ID's added as a crew member.
    def with_crew(crew : Int64)
      @with_crew = [] of Int64 if @with_crew.nil?
      @with_crew.not_nil! << crew
      self
    end

    def with_crew(crew : Array(Int64))
      @with_crew = [] of Int64 if @with_crew.nil?
      @with_crew = @with_crew.not_nil! + crew
      self
    end

    # A comma separated list of person ID's. Only include movies that have one
    # of the ID's added as an actor or crew member.
    def with_people(person : Int64)
      @with_people = [] of Int64 if @with_people.nil?
      @with_people.not_nil! << person
      self
    end

    def with_people(persons : Array(Int64))
      @with_people = [] of Int64 if @with_people.nil?
      @with_people = @with_people.not_nil! + persons
      self
    end

    # A comma separated list of production company ID's. Only include movies
    # that have one of the ID's added as a production company.
    def with_companies(company : Int32)
      @with_companies = [] of Int32 if @with_companies.nil?
      @with_companies.not_nil! << company
      self
    end

    def with_companies(companies : Array(Int32))
      @with_companies = [] of Int32 if @with_companies.nil?
      @with_companies = @with_companies.not_nil! + companies
      self
    end

    # Comma separated value of genre ids that you want to include in the
    # results.
    def with_genres(genre : Int32)
      @with_genres = [] of Int32 if @with_genres.nil?
      @with_genres.not_nil! << genre
      self
    end

    def with_genres(genres : Array(Int32))
      @with_genres = [] of Int32 if @with_genres.nil?
      @with_genres = @with_genres.not_nil! + genres
      self
    end

    # A comma separated list of keyword ID's. Only includes movies that have
    # one of the ID's added as a keyword.
    def with_keywords(keyword : String)
      @with_keyword = [] of String if @with_keyword.nil?
      @with_keyword.not_nil! << keyword
      self
    end

    def with_keywords(keywords : Array(String))
      @with_keyword = [] of String if @with_keyword.nil?
      @with_keyword = @with_keyword.not_nil! + keywords
      self
    end

    # Exclude items with certain keywords. You can comma and pipe seperate
    # these values to create an 'AND' or 'OR' logic.
    def without_keywords(keyword : String)
      @without_keyword = [] of String if @without_keyword.nil?
      @without_keyword.not_nil! << keyword
      self
    end

    def without_keywords(keywords : String)
      @without_keyword = [] of String if @without_keyword.nil?
      @without_keyword = @without_keyword.not_nil! + keywords
      self
    end

    # Filter and only include movies that have a runtime that is greater or
    # equal to a value.
    def with_runtime_gte(@with_runtime_gte : Int32)
      self
    end

    # Filter and only include movies that have a runtime that is less or
    # equal to a value.
    def with_runtime_lte(@with_runtime_lte : Int32)
      self
    end

    # Specify an ISO 639-1 string to filter results by their original language
    # value.
    def with_original_language(@with_original_language : String)
      self
    end

    # A comma or pipe separated list of watch provider ID's. Combine this
    # filter with `watch_region` in order to filter your results by a specific
    # watch provider in a specific region.
    def with_watch_providers(watch_provider : String)
      @with_watch_providers = [] of String if @with_watch_providers.nil?
      @with_watch_providers.not_nil! << watch_provider
      self
    end

    def with_watch_providers(watch_providers : Array(String))
      @with_watch_providers = [] of String if @with_watch_providers.nil?
      @with_watch_providers = @with_watch_providers.not_nil! + watch_providers
      self
    end

    # An ISO 3166-1 code. Combine this filter with `with_watch_providers` in
    # order to filter your results by a specific watch provider in a specific
    # region.
    def watch_region(@watch_region : String)
      self
    end

    # In combination with `watch_region`, you can filter by monetization type.
    def with_watch_monetization_types(@with_watch_monetization_types : MonetizationType)
      self
    end

    def to_filter : FilterFactory::Filter
      filters = FilterFactory::Filter.new

      filters[:language] = @language.not_nil! unless @language.nil?
      filters[:region] = @region.not_nil! unless @region.nil?
      filters[:sort_by] = @sort_by.not_nil!.to_s unless @sort_by.nil?
      filters[:certification_country] = @certification_country.not_nil! unless @certification_country.nil?
      filters[:certification] = @certification.not_nil! unless @certification.nil?
      filters[:"certification.lte"] = @certification_lte.not_nil! unless @certification_lte.nil?
      filters[:"certification.gte"] = @certification_gte.not_nil! unless @certification_gte.nil?
      filters[:include_adult] = @include_adult.not_nil!.to_s unless @include_adult.nil?
      filters[:include_video] = @include_video.not_nil!.to_s unless @include_video.nil?
      filters[:primary_release_year] = @primary_release_year.not_nil!.to_s unless @primary_release_year.nil?
      filters[:"primary_release_date.gte"] =
        @primary_release_date_gte.not_nil!.to_s("%Y-%m-%d") unless @primary_release_date_lte.nil?
      filters[:"primary_release_date.lte"] =
        @primary_release_date_lte.not_nil!.to_s("%Y-%m-%d") unless @primary_release_date_lte.nil?
      filters[:"release_date.gte"] = @release_date_gte.not_nil!.to_s("%Y-%m-%d") unless @release_date_gte.nil?
      filters[:"release_date.lte"] = @release_date_lte.not_nil!.to_s("%Y-%m-%d") unless @release_date_lte.nil?
      filters[:with_release_type] = @with_release_type.not_nil!.to_s unless @with_release_type.nil?
      filters[:year] = @year.not_nil!.to_s unless @year.nil?
      filters[:"vote_count.lte"] = @vote_count_lte.not_nil!.to_s unless @vote_count_lte.nil?
      filters[:"vote_count.gte"] = @vote_count_gte.not_nil!.to_s unless @vote_count_gte.nil?
      filters[:"vote_average.gte"] = @vote_average_gte.not_nil!.to_s unless @vote_average_gte.nil?
      filters[:"vote_average.lte"] = @vote_average_lte.not_nil!.to_s unless @vote_average_lte.nil?
      filters[:with_cast] = @with_cast.not_nil!.join(",") unless @with_cast.nil?
      filters[:with_crew] = @with_crew.not_nil!.join(",") unless @with_crew.nil?
      filters[:with_people] = @with_people.not_nil!.join(",") unless @with_people.nil?
      filters[:with_companies] = @with_companies.not_nil!.join(",") unless @with_companies.nil?
      filters[:with_genres] = @with_genres.not_nil!.join(",") unless @with_genres.nil?
      filters[:without_genres] = @without_genres.not_nil!.join(",") unless @without_genres.nil?
      filters[:with_keywords] = @with_keywords.not_nil!.join(",") unless @with_keywords.nil?
      filters[:without_keywords] = @without_keywords.not_nil!.join(",") unless @without_keywords.nil?
      filters[:"with_runtime.gte"] = @with_runtime_gte.not_nil!.to_s unless @with_runtime_gte.nil?
      filters[:"with_runtime.lte"] = @with_runtime_lte.not_nil!.to_s unless @with_runtime_lte.nil?
      filters[:with_original_language] = @with_original_language.not_nil! unless @with_original_language.nil?
      filters[:with_watch_providers] = @with_watch_providers.not_nil!.join(",") unless @with_watch_providers.nil?
      filters[:watch_region] = @watch_region.not_nil! unless @watch_region.nil?
      filters[:with_watch_monetization_types] =
        @with_watch_monetization_types.not_nil!.to_s unless @with_watch_monetization_types.nil?

      # TV filters
      filters[:"air_date.gte"] = @air_date_gte.not_nil!.to_s("%Y-%m-%d") unless @air_date_gte.nil?
      filters[:"air_date.lte"] = @air_date_lte.not_nil!.to_s("%Y-%m-%d") unless @air_date_lte.nil?
      filters[:"first_air_date.gte"] = @first_air_date_gte.not_nil!.to_s("%Y-%m-%d") unless @first_air_date_gte.nil?
      filters[:"first_air_date.lte"] = @first_air_date_lte.not_nil!.to_s("%Y-%m-%d") unless @first_air_date_lte.nil?
      filters[:first_air_date_year] = @first_air_date_year.not_nil!.to_s unless @first_air_date_year.nil?
      filters[:timezone] = @timezone.not_nil! unless @timezone.nil?
      filters[:with_networks] = @with_networks.not_nil!.join(",") unless @with_networks.nil?
      filters[:include_null_first_air_dates] =
        @include_null_first_air_dates.not_nil!.to_s unless @include_null_first_air_dates.nil?
      filters[:screened_theatrically] = @screened_theatrically.not_nil!.to_s unless @screened_theatrically.nil?

      filters
    end
  end

  # Discover movies by different types of data like average rating, number of
  # votes, genres and certifications. You can get a valid list of
  # certifications from the
  # [certifications list](https://developers.themoviedb.org/3/certifications/get-movie-certifications) method.
  #
  # Discover also supports a nice list of sort options. See below for all of
  # the available options.
  #
  # Please note, when using `certification` \ `certification.lte` you must also
  # specify `certification_country`. These two parameters work together in
  # order to filter the results. You can only filter results with the countries
  # we have added to our [certifications list](https://developers.themoviedb.org/3/certifications/get-movie-certifications).
  #
  # If you specify the `region` parameter, the regional release date will be
  # used instead of the primary release date. The date returned will be the
  # first date based on your query (ie. if a `with_release_type` is specified).
  # It's important to note the order of the release types that are used.
  # Specifying "2|3" would return the limited theatrical release date as
  # opposed to "3|2" which would return the theatrical date.
  #
  # Also note that a number of filters support being comma (`,`) or pipe (`|`)
  # separated. Comma's are treated like an `AND` and query while pipe's are an
  # `OR`.
  #
  # Some examples of what can be done with discover can be found [here](https://www.themoviedb.org/documentation/api/discover).
  def self.movies(filters : FilterFactory::Filter, skip_cache : Bool = false) : LazyIterator(MovieResult)
    res = Resource.new("/discover/movie", filters)
    LazyIterator(MovieResult).new(res, skip_cache: skip_cache)
  end

  # Discover TV shows by different types of data like average rating, number of
  # votes, genres and certifications. You can get a valid list of
  # certifications from the
  # [certifications list](https://developers.themoviedb.org/3/certifications/get-movie-certifications) method.
  #
  # Discover also supports a nice list of sort options. See below for all of
  # the available options.
  #
  # Please note, when using `certification` \ `certification.lte` you must also
  # specify `certification_country`. These two parameters work together in
  # order to filter the results. You can only filter results with the countries
  # we have added to our [certifications list](https://developers.themoviedb.org/3/certifications/get-movie-certifications).
  #
  # If you specify the `region` parameter, the regional release date will be
  # used instead of the primary release date. The date returned will be the
  # first date based on your query (ie. if a `with_release_type` is specified).
  # It's important to note the order of the release types that are used.
  # Specifying "2|3" would return the limited theatrical release date as
  # opposed to "3|2" which would return the theatrical date.
  #
  # Also note that a number of filters support being comma (`,`) or pipe (`|`)
  # separated. Comma's are treated like an `AND` and query while pipe's are an
  # `OR`.
  #
  # Some examples of what can be done with discover can be found [here](https://www.themoviedb.org/documentation/api/discover).
  def self.tv_shows(filters : FilterFactory::Filter, skip_cache : Bool = false) : LazyIterator(Tv::ShowResult)
    res = Resource.new("/discover/tv", filters)
    LazyIterator(Tv::ShowResult).new(res, skip_cache: skip_cache)
  end
end
