require "./person"

abstract class Tmdb::Credit
  abstract def original_name : String
  abstract def credit_id : String
  abstract def person : Person
end

require "./cast_credit"
require "./crew_credit"
