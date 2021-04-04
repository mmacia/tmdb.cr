class Tmdb::LazyIterator(T)
  include Enumerable(JSON::Any)
  getter resource : Resource
  @total_items : Int32 = 0

  private getter items_per_page : Int32 = 0
  private getter total_pages : Int32 = 0
  private getter? fetched : Bool = false

  def initialize(@resource : Resource)
  end

  def each(&block)
    finished = false

    resource.params[:page] = 1.to_s unless resource.params[:page]?

    until finished
      payload = resource.get
      update_counters(payload)

      payload["results"].as_a.each do |item|
        yield T.new(item)
      end

      finished = true if cur_page > total_pages
      resource.params[:page] = (resource.params[:page].to_i + 1).to_s
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
    @items_per_page = 20
    @total_pages = payload["total_pages"].as_i
    nil
  end
end
