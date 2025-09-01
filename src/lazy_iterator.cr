require "json"

class Tmdb::LazyIterator(T)
  include Enumerable(T)
  getter resource : Resource
  @total_items : Int32 = 0

  private getter total_pages : Int32 = 0
  private getter? fetched : Bool = false
  private getter max_pages : Int32
  private getter? skip_cache : Bool
  private getter initializer : JSON::Any -> T

  def initialize(
    @resource : Resource,
    @max_pages : Int32 = 500,
    @skip_cache : Bool = false,
    @initializer : JSON::Any -> T = ->(item : JSON::Any) { T.new(item) }
    )
  end

  def each(&block)
    finished = false

    resource.params[:page] = 1.to_s unless resource.params[:page]?

    until finished
      payload = resource.get skip_cache?
      update_counters(payload)

      payload["results"].as_a.each do |item|
        yield initializer.call(item)
      end

      resource.params[:page] = (resource.params[:page].to_i + 1).to_s
      finished = true if cur_page > total_pages || resource.params[:page].to_i > max_pages
      @fetched = true
    end
  end

  def total_items : Int32
    first unless fetched? # prefetch first page to get totals
    resource.params[:page] = 1.to_s
    @total_items
  rescue Enumerable::EmptyError
    0
  end

  private def cur_page : Int32
    resource.params[:page].to_i
  end

  private def update_counters(payload : JSON::Any)
    @total_items = payload["total_results"].as_i
    @total_pages = payload["total_pages"].as_i
    nil
  end
end
