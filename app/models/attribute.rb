class Attribute
  include Mongoid::Document
  field :name, type: String
  field :abbrev, type: String
end
