class CharacterClass
  include Mongoid::Document
  field :name, type: String
  field :baseHp, type: Integer
  field :recoveryDie, type: Integer
  field :basePd, type: Integer
  field :baseMd, type: Integer
  field :defaultAc, type: Integer
  field :numTalents, type: Integer
  field :numBackgrounds, type: Integer
  field :default1hWeaponDie, type: Integer
  field :default2hWeaponDie, type: Integer
  field :defaultThrownDie, type: Integer
  field :defaultBowDie, type: Integer
  field :shieldPenalty, type: Integer
  field :meleeMissDmg, type: Mongoid::Boolean
  field :rangedMissDmg, type: Mongoid::Boolean

  accepts_nested_attributes_for :powers, as: :power_by_level
  embeds_many :powers
  embeds_many :talents

end
