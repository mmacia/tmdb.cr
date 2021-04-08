class Tmdb::Company
  getter id : Int64
  getter logo_path : String?
  getter name : String
  getter origin_country : String
  @description : String? = nil
  @headquarters : String? = nil
  @homepage : String? = nil
  @parent_company : Company? = nil

  private getter? full_initialized : Bool

  def self.detail(id : Int64) : Company
    res = Resource.new("/company/#{id}")
    Company.new(res.get)
  end

  def initialize(data : JSON::Any)
    @description = data["description"].as_s
    @headquarters = data["headquarters"].as_s
    @homepage = data["homepage"].as_s
    @id = data["id"].as_i64
    @origin_country = data["origin_country"].as_s
    @logo_path = data["logo_path"].as_s?
    @name = data["name"].as_s

    if data["parent_company"]?
      pc = data["parent_company"]
      @parent_company = Company.new(
        id: pc["id"].as_i64,
        name: pc["name"].as_s,
        logo_path: pc["logo_path"].as_s?,
        origin_country: pc["origin_country"].as_s
      )
    end

    @full_initialized = true
  end

  def initialize(@id, @name, @logo_path, @origin_country)
    @full_initialized = false
  end

  def description : String
    refresh! unless full_initialized?
    @description.not_nil!
  end

  def headquarters : String
    refresh! unless full_initialized?
    @headquarters.not_nil!
  end

  def homepage : String
    refresh! unless full_initialized?
    @homepage.not_nil!
  end

  def parent_company : Company?
    refresh! unless full_initialized?
    @parent_company
  end

  private def refresh!
    obj = Company.detail(id)

    @description = obj.description
    @headquarters = obj.headquarters
    @homepage = obj.homepage
    @id = obj.id
    @origin_country = obj.origin_country
    @logo_path = obj.logo_path
    @name = obj.name
    @parent_company = obj.parent_company

    @full_initialized = true
  end
end
