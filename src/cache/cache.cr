abstract class Tmdb::Cache(T)
  abstract class Info
    abstract def created_at : Time
    abstract def size : Int64
  end

  abstract def get(key : String) : T
  abstract def put(key : String, object : T) : Nil
  abstract def evict(key : String) : Nil
  abstract def info(key : String) : Info
end

class Tmdb::CacheMiss < Exception; end

module Tmdb::Cacheable
  def cache_aware(key : String)
    if Tmdb.api.cache
      cache_item = JSON.parse(Tmdb.api.cache.not_nil!.get(key))

      { body: cache_item["body"],
        status_code: cache_item["status_code"].as_i }
    else
      yield
    end
  rescue CacheMiss
    obj = yield
    Tmdb.api.cache.not_nil!.put(key, obj.to_json)
    obj
  end

  private def make_cache_key(url, method, headers) : String
    obj = {
      method: method,
      url: url,
      headers: headers
    }.to_json

    Digest::MD5.hexdigest(obj)
  end
end
