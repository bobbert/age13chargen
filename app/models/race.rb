class Race
  include Mongoid::Document
  field :name, type: String
  field :alternateName, type: String
  field :abilityBonuses, type: Array

  embeds_many :feats
end
