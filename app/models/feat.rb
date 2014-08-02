class Feat
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :prereq, type: Hash

  embeds_one :tier

  embedded_in :power
  embedded_in :race
  embedded_in :talent
end
