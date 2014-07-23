# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



srd_path = Dir.glob(Rails.root.to_s + "/db/srd_core.json").first
srd = JSON.parse(open(srd_path).read, :symbolize_names=>true)
srd_lookup = {}
reverse_lookup = {}

# creating defaults
top_keys = [:tiers, :ability_scores, :point_buys, :levels, :races, :character_classes, :powers, :talents, :feats]
top_keys.each do |top_key| 
  srd[top_keys] ||= []
  srd_lookup[top_key] = {}
end

fields = {
  tiers: [:name, :multiplier], 
  ability_scores: [:name, :abbrev], 
  point_buys: [:ability_score, :cost], 
  levels: [:level, :hpMultiplier, :abilityBonuses], 
  races: [:name, :alternateName, :abilityBonuses], 
  character_classes: [:name, :baseHp, :recoveryDie, :basePd, :baseMd, :defaultAc, :numTalents, 
    :numBackgrounds, :default1hWeaponDie, :default2hWeaponDie, :defaultThrownDie, :defaultBowDie, 
    :shieldPenalty, :meleeMissDmg, :rangedMissDmg, :abilityBonuses, :powersByLevel], 
  powers: [:name, :type, :attacktype, :usage, :description], 
  talents: [:name, :type, :description], 
  feats: [:name, :description, :prereq]
}

assign_to_reverse_lookup = lambda do |type, key, value|
  reverse_lookup[type] ||= {}
  reverse_lookup[type][key] = value
end

create_and_assign_to_srd_lookup = lambda do |clazz, clazz_obj, key_field|
  record_name = clazz.to_s.underscore.pluralize.to_sym
  if (fields[record_name])
    # creating new ActiveModel record with only valid fields
    clean_fields_obj = clazz_obj.slice(*fields[record_name])
    record = clazz.new clean_fields_obj
    srd_lookup[record_name][clazz_obj[key_field]] = record
  end
end

#------------------------#

# seeding ActiveModel records without embedding
srd[:ability_scores].each do |ability_score_obj|
  ability_score = AbilityScore.create! ability_score_obj
end

srd[:point_buys].each do |point_buy_obj|
  point_buy = PointBuy.create! point_buy_obj
end

# seeding ActiveModel records that embed or are embedded by other records, in order from children to parents.
# Child records (Tier, Level, Feat, Power, Talent) get saved to SRD lookup object
# Parent records (CharacterClass, Race) get persisted to Mongo.

srd[:tiers].each do |tier_obj|
  create_and_assign_to_srd_lookup.call(Tier, tier_obj, :name)
end

srd[:levels].each do |level_obj|
  level_obj[:tier] = srd_lookup[:tiers][level_obj[:tier]] if level_obj[:tier] # Level -> Tier
  create_and_assign_to_srd_lookup.call(Level, level_obj, :level)
end

srd[:feats].each do |feat_obj|
  feat_obj[:tier] = srd_lookup[:tiers][feat_obj[:tier]] if feat_obj[:tier] # Feat -> Tier
  create_and_assign_to_srd_lookup.call(Feat, feat_obj, :name)
end

srd[:talents].each do |talent_obj|
  talent_obj[:tier] = srd_lookup[:talents][talent_obj[:tier]] if talent_obj[:tier] # Talent -> Tier
  create_and_assign_to_srd_lookup.call(Talent, talent_obj, :name)
end

srd[:powers].each do |power_obj|
  power_obj[:level] = srd_lookup[:powers][power_obj[:level]] if power_obj[:level] # Power -> Level
#  power_obj[:feat] = srd_lookup[:powers][power_obj[:feat]] if power_obj[:feat] # Power -> Feat
  create_and_assign_to_srd_lookup.call(Power, power_obj, :name)
end

srd[:races].each do |race_obj|
  create_and_assign_to_srd_lookup.call(Race, race_obj, :name)
end

srd[:character_classes].each do |character_class_obj|
  create_and_assign_to_srd_lookup.call(CharacterClass, character_class_obj, :name)
end

# performing child-parent associations


# saving root-level records

srd_lookup[:races].values.each {|race_obj| race_obj.save! }
srd_lookup[:character_classes].values.each {|character_class_obj| character_class_obj.save! }