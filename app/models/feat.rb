class Feat
  include Mongoid::Document
  field :uniqueName, type: String
  field :name, type: String
  field :prereqType, type: String
  field :description, type: String
end
