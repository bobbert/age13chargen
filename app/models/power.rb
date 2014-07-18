class Power
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :attacktype, type: String
  field :usage, type: String
  field :description, type: String

  embeds_many :feat
  embeds_one :tier
  embeds_one :level

  embedded_in :character_class
end
