require "./tmdb"

Tmdb.configure do |conf|
  conf.api_key = "dd3079d9ec0b6957170cbcb8d25ef38c"
  conf.default_language = "en"
end

results = Tmdb::Search.movie("terminator", language: "es")
pp results

results.each do |m|
  pp movie
end

pp results.total_items
