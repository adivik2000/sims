# == Schema Information
# Schema version: 20081125030310
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
  has_many :states

  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}

  validates_uniqueness_of :admin, :if=> lambda{|c| c.admin?}   #Only 1 admin country
  validates_presence_of :name,:abbrev
  validates_uniqueness_of :name,:abbrev
  
end
