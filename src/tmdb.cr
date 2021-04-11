require "./api"
require "./resource"
require "./search"
require "./configuration"
require "./certification"
require "./collection"
require "./company"
require "./credit"
require "./keyword"

# discover
# find
# jobs
# networks
# people
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
