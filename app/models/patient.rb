class Patient < ActiveRecord::Base
  has_many :audiograms
  has_many :examiners, :through => :audiograms
  attr_accessible :hp_id
end
