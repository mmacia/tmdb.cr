require "../spec_helper"

describe Tmdb::FileCache do

  context "#get" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir)
    payload = "The quick brown fox jumps over the lazy dog"
    key = Digest::MD5.hexdigest(payload)

    Spec.before_suite { cache.put(key, payload) }
    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should get a key" do
      item = cache.get(key)
      item.should eq(payload)
    end

    it "should raise a cache miss exception on unknown key" do
      expect_raises Tmdb::CacheMiss do
        cache.get("notexists")
      end
    end
  end

  context "#put" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir, 2.to_i64)
    payload = "The quick brown fox jumps over the lazy dog"
    key = Digest::MD5.hexdigest(payload)

    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should write an object" do
      before = Dir.entries(tmpdir)
      cache.put(key, payload)
      after = Dir.entries(tmpdir)

      before.includes?(key).should be_false
      after.should contain(key)
    end

    it "should remove LRU item and write a new object" do
      payload2 = "lorem ipsum dolor sit amet, consectetur adipiscing elit"
      key2 = Digest::MD5.hexdigest(payload2)

      payload3 = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium"
      key3 = Digest::MD5.hexdigest(payload3)

      sleep(1)
      cache.put key2, payload2

      before = Dir.entries(tmpdir)
      sleep(1)
      cache.put key3, payload3
      after = Dir.entries(tmpdir)

      before.includes?(key3).should be_false
      after.should contain(key3)
      after.includes?(key).should be_false
    end
  end

  context "#evict" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir, 2.to_i64)
    payload = "The quick brown fox jumps over the lazy dog"
    key = Digest::MD5.hexdigest(payload)

    Spec.before_suite { cache.put key, payload }
    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should evict a key" do
      before = Dir.entries(tmpdir)
      cache.evict key
      after = Dir.entries(tmpdir)

      before.should contain(key)
      after.includes?(key).should be_false
    end

    it "should evict a non existent key" do
      before = Dir.entries(tmpdir)
      cache.evict "notexists"
      after = Dir.entries(tmpdir)

      before.should eq(after)
    end
  end

  context "#info" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir, 2.to_i64)
    payload = "The quick brown fox jumps over the lazy dog."
    key = Digest::MD5.hexdigest(payload)

    Spec.before_suite { cache.put key, payload }
    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should get info from a key" do
      info = cache.info(key)

      info.should be_a(Tmdb::Cache::Info)
      info.size.should eq(44)
      info.created_at.should be_close(Time.utc, 5.seconds)
    end
  end

  context "#clear" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir, 2.to_i64)
    payload = "The quick brown fox jumps over the lazy dog."
    key = Digest::MD5.hexdigest(payload)

    Spec.before_suite { cache.put key, payload }
    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should clear cache" do
      before = Dir.entries(tmpdir)
      cache.clear
      after = Dir.entries(tmpdir)

      before.size.should eq(3)
      (after.size - 2).should eq(0)
    end
  end

  context "#ratio" do
    tmpdir = File.join(Dir.tempdir, "tmdb_#{Random.new.hex(6)}")
    cache = Tmdb::FileCache.new(tmpdir, 2.to_i64)
    payload = "The quick brown fox jumps over the lazy dog."
    key = Digest::MD5.hexdigest(payload)

    Spec.before_suite { cache.put key, payload }
    Spec.after_suite { FileUtils.rm_rf tmpdir }

    it "should get hit/miss cache ratio" do
      before = cache.ratio
      3.times { cache.get key }
      after = cache.ratio

      before.should eq(0.0)
      after.should eq(1.0)
      cache.hits.should eq(3)
      cache.misses.should eq(0)
    end
  end
end
