require "./api"
require "./resource"
require "./search"
require "./configuration"

# configuration
# certifiactes
# changes
# collections
# companies
# credits
# discover
# find
# genres
# jobs
# keywords
# movies
# networks
# people
# recommendations
# reviews
# tv
# tv seasons
# tv episodes

module Tmdb
  VERSION = "0.1.0"
  @@api : Api? = nil

  def self.configure
    api = Api.new
    yield api
    @@api = api
  end

  def self.api : Api
    @@api.not_nil!
  end
end
