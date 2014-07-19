class Tier
  include Mongoid::Document
  field :name, type: String
  field :multiplier, type: Integer

  embedded_in :feat
  embedded_in :level
  embedded_in :power
  embedded_in :talent
end
