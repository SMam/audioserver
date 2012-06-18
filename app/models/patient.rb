class Patient < ActiveRecord::Base
  has_many :audiograms
  has_many :examiners, :through => :audiograms
  attr_accessible :hp_id

  validate :hp_id_is_valid
end

def hp_id_is_valid
  require 'id_validation'
  unless valid_id?(self.hp_id)
    errors.add(:hp_id, "Invalid ID")
  end
end
