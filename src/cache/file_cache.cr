require "./cache"
require "file_utils"

class Tmdb::FileCache < Tmdb::Cache(String)
  class Info < Tmdb::Cache::Info
    private getter file : String

    def initialize(@file)
    end

    def created_at : Time
      File.info(file).modification_time
    end

    def size : Int64
      File.info(file).size
    end
  end

  getter store_dir : String
  getter max_items : Int64
  getter hits : UInt64 = 0.to_u64
  getter misses : UInt64 = 0.to_u64

  @cache_items : UInt64 = 0.to_u64

  def initialize(@store_dir : String, @max_items : Int64 = 1_000.to_i64)
    FileUtils.mkdir_p(store_dir) unless File.exists? store_dir
  end

  def initialize(@store_dir : String, max_items : Int32)
    initialize(@store_dir, max_items.to_i64)
  end

  def get(key : String) : String
    cache_file = File.join(store_dir, key)

    if File.exists? cache_file
      @hits += 1
      File.read(cache_file)
    else
      @misses += 1
      raise CacheMiss.new
    end
  end

  def put(key : String, object : String) : Nil
    evict_older_item if needed_to_evict?
    cache_file = File.join(store_dir, key)
    File.write(cache_file, object)
    @cache_items += 1
    nil
  end

  def evict(key : String) : Nil
    FileUtils.rm File.join(store_dir, key)
    @cache_items -= 1
    nil
  rescue File::NotFoundError
    nil
  end

  def info(key : String) : Info
    Info.new(File.join(store_dir, key))
  end

  def clear : Nil
    @hits = 0.to_u64
    @misses = 0.to_u64
    @cache_items = 0.to_u64

    Dir.each(store_dir) do |f|
      File.delete(File.join(store_dir, f)) unless [".", ".."].includes?(f)
    end

    nil
  end

  def ratio : Float64
    return 0.0 if (hits + misses) == 0
    hits / (hits + misses)
  end

  private def needed_to_evict? : Bool
    @cache_items >= @max_items
  end

  private def evict_older_item : Nil
    dir = Dir.new(store_dir)

    file = dir.reject do |f|
      [".", ".."].includes? f
    end.min_by do |f|
      File.info(File.join(store_dir, f)).modification_time
    end

    key = File.basename(file)
    evict(key)
  end
end
