class Level
  include Mongoid::Document
  field :level, type: Integer
  field :hpMultiplier, type: Integer
  field :abilityBonuses, type: Integer
end
