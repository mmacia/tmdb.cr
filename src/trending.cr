require "./movie"
require "./tv/show"
require "./person"

class Tmdb::Trending
  enum TimeWindow
    Day
    Week
  end

  # Get the daily or weekly trending movies. The daily trending list tracks
  # items over the period of a day while items have a 24 hour half life. The
  # weekly list tracks items over a 7 day period, with a 7 day half life.
  def self.trending_movies(time_window : TimeWindow) : LazyIterator(MovieResult)
    res = Resource.new("/trending/movie/#{time_window.to_s.downcase}")
    LazyIterator(MovieResult).new(res, max_pages: 1_000)
  end

  # Get the daily or weekly trending TV shows. The daily trending list tracks
  # items over the period of a day while items have a 24 hour half life. The
  # weekly list tracks items over a 7 day period, with a 7 day half life.
  def self.trending_tv_shows(time_window : TimeWindow) : LazyIterator(Tv::ShowResult)
    res = Resource.new("/trending/tv/#{time_window.to_s.downcase}")
    LazyIterator(Tv::ShowResult).new(res, max_pages: 1_000)
  end

  # Get the daily or weekly trending people. The daily trending list tracks
  # items over the period of a day while items have a 24 hour half life. The
  # weekly list tracks items over a 7 day period, with a 7 day half life.
  def self.trending_people(time_window : TimeWindow) : LazyIterator(PersonResult)
    res = Resource.new("/trending/person/#{time_window.to_s.downcase}")
    LazyIterator(PersonResult).new(res, max_pages: 1_000)
  end
end
