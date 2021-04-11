require "spec"
require "vcr"
require "../src/tmdb"

VCR.configure do |settings|
  settings.filter_sensitive_data["api_key"] = "<API_KEY>"
end
