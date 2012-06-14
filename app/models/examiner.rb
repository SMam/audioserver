class Examiner < ActiveRecord::Base
  has_many :audiograms
  has_many :patients, :through => :audiograms
  attr_accessible :worker_id
end
