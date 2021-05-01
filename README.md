# The Movie Database API

A Crystal wrapper for the [The Movie DAtabase API](https://developers.themoviedb.org/).

## Installation

Add this lines to your `shards.yml` file:

```
dependencies:
  tmdb:
    github: mmacia/tmdb.cr
    branch: master
```

Then run `shards install` from your project.

## Usage

### Initial configuration

You have to provide your API key like this:

```
Tmdb.configure do |conf|
  conf.api_key = "secret"
  conf.default_language = "en"
end
```

You can also set the API key in environment variable `TMDB_API_KEY`. The value
of this variable has higher precedence.

The default language is english, but you can temporarily override the global
language for a single request by specifying it as an additional parameter:

```
# example
Tmdb::Search.movies("terminator", language: "es")
```

You can save a few API calls activating the cache:

```
Tmdb.configure do |conf|
  conf.cache = Tmdb::FileCache.new("/tmp/tmdb", 10_000)
end
```

Paginated resources are managed by `LazyIterator(T)` class. This acts as a
infinite iterator, you just have to call `#each`, `#select`, `#map` or whatever
enumerable method to acces to the whole collection without worrying about
pagination.

```
# example
movies = Tmdb::Search.movies("terminator")

pp movies.total_items

movies.each do |m|
  pp m.original_title
end
```

### Endpoints

All endpoints available are those listed in The Movie Database API
documentation.

Missing endpoints:
 * Account
 * Authentication
 * Guest Sessions
 * Lists
 * Multi search


## Contributing

1. Fork it (<https://github.com/your-github-user/tmdb/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Moisès Macià](https://github.com/your-github-user) - creator and maintainer
