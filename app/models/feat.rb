class Feat
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  embeds_one :tier

  embedded_in :power
  embedded_in :race
end
