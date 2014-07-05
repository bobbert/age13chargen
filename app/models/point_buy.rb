class PointBuy
  include Mongoid::Document
  field :ability_score, type: Integer
  field :cost, type: Integer
end
