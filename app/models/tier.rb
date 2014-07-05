class Tier
  include Mongoid::Document
  field :name, type: String
  field :multiplier, type: Integer
end
