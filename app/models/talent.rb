class Talent
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :description, type: String

  embeds_one :tier
  embeds_many :feats

  embedded_in :character_class

end
