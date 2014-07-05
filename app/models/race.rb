class Race
  include Mongoid::Document
  field :name, type: String
  field :alternateName, type: String
end
