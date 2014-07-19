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

# creating defaults
top_keys = [:tiers, :ability_scores, :point_buys, :levels, :races, :character_classes, :powers, :talents, :feats]
top_keys.each do |top_key| 
  srd[top_keys] ||= []
  srd_lookup[top_key] = {}
end

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
  tier = Tier.new tier_obj
  srd_lookup[:tiers][tier_obj[:name]] = tier
end

srd[:levels].each do |level_obj|
  level_obj[:tier] = srd_lookup[:tiers][level_obj[:tier]] # Level -> Tier
  level = Level.new level_obj
  srd_lookup[:levels][level_obj[:level]] = level
end

srd[:feats].each do |feat_obj|
  feat_obj[:tier] = srd_lookup[:tiers][feat_obj[:tier]] # Feat -> Tier
  feat = Feat.new feat_obj
  srd_lookup[:feats][feat_obj[:name]] = feat
end

srd[:talents].each do |feat_obj|
  feat_obj[:tier] = srd_lookup[:talents][feat_obj[:tier]] # Talent -> Tier
  feat = Feat.new feat_obj
  srd_lookup[:talents][feat_obj[:name]] = feat
end



