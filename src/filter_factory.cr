class Tmdb::FilterFactory
  alias Filter = Hash(Symbol, String)

  def self.create(**kwargs) : Filter
    filter = Filter.new
    kwargs.each do |k, v|
      filter[k] = v.to_s
    end

    filter
  end

  def self.create_language(language : String?) : Filter
    filter = Filter.new
    filter[:language] = language.nil? ? Tmdb.api.default_language : language.not_nil!

    filter
  end

  def self.create_country(country : String?) : Filter
    filter = Filter.new
    filter[:country] = country.not_nil! unless country.nil?

    filter
  end
end
