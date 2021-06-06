# The Movie Database API

A Crystal wrapper for the [The Movie Database API](https://developers.themoviedb.org/).

[![build](https://github.com/mmacia/tmdb.cr/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/mmacia/tmdb.cr/actions/workflows/build.yml)

## Installation

Add this lines to your `shards.yml` file:

```yaml
dependencies:
  tmdb:
    github: mmacia/tmdb.cr
    branch: master
```

Then run `shards install` from your project.

## Usage

### Initial configuration

You have to provide your API key like this:

```crystal
Tmdb.configure do |conf|
  conf.api_key = "secret"
  conf.default_language = "en"
end
```

You can also set the API key in environment variable `TMDB_API_KEY`. The value
of this variable has higher precedence.

```
$ export TMDB_API_KEY='secret'
```

The default language is english, but you can temporarily override the global
language for a single request by specifying it as an additional parameter:

```crystal
# example
Tmdb::Search.movies("terminator", language: "es")
```

You can save a few API calls activating the cache:

```crystal
Tmdb.configure do |conf|
  conf.cache = Tmdb::FileCache.new("/tmp/tmdb", 10_000)
end
```

Paginated resources are managed by `LazyIterator(T)` class. This acts as a
infinite iterator, you just have to call `#each`, `#select`, `#map` or whatever
enumerable method to acces to the whole collection without worrying about
pagination.

```crystal
# example
movies = Tmdb::Search.movies("terminator")

pp movies.total_items

movies.each do |m|
  pp m.original_title
end
```

### Get a movie by ID

Get the movie information for specific movie ID.

```crystal
Tmdb::Movie.detail 24

Tmdb::Movie.detail 24, language: "es"
```

### Search movies

Search movies by title.

```crystal
Tmdb::Search.movies "terminator"
```

Search movies by title and release year.

```crystal
Tmdb::Search.movies "terminator", year: 1984
```

### Alternative titles

Get the alternative titles for a specific movie.

```crystal
movie = Tmdb::Movie.detail 24
movie.alternative_titles country: "es"
```

### Cast

Get the cast for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.cast language: "it"
```

### Crew

Get the crew for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.cast language: "de"
```

### Movie images

Get the images (posters and backdrops) for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.images
```

### Movie keywords

Get the plot keywords for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.keywords
```

### Movie trailers

Get the release trailers for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.videos
```

### Movie releases

Get the release dates by country for a specific movie ID.

```crystal
movie = Tmdb::Movie.detail 24
movie.release_dates
```

### Upcoming movies

Get the list of upcoming movies. This list refreshes every day.

```crystal
Tmdb::Movie.upcoming
```

You can get the upcoming movie for a region.

```crystal
Tmdb::Movie.upcoming region: "pt"
```

### Find a person by ID

Get the basic person information for a specific person ID.

```crystal
Tmdb::Person.detail 138
```

### Search people

Seach for people by name.

```crystal
Tmdb::Search.people "Paul"
```

### Popular people

Gets a list of popular people. This list refreshes every day.

```crystal
Tmdb::People.popular
```

## Endpoints

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
