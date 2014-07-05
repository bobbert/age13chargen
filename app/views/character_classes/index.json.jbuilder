json.array!(@character_classes) do |character_class|
  json.extract! character_class, :id, :name, :baseHp, :recoveryDie, :basePd, :baseMd, :defaultAc, :numTalents, :numBackgrounds, :default1hWeaponDie, :default2hWeaponDie, :defaultThrownDie, :defaultBowDie, :shieldPenalty, :meleeMissDmg, :rangedMissDmg
  json.url character_class_url(character_class, format: :json)
end
