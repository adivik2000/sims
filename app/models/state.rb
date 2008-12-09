# == Schema Information
# Schema version: 20081208201532
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

class State < ActiveRecord::Base
  belongs_to :country
  has_many :districts
  has_many :news,:class_name=>"NewsItem"
  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}
  
  validates_uniqueness_of :admin, :scope=>:country_id, :if=>lambda{|s| s.admin?}  #only 1 admin state per country
  validates_uniqueness_of :country_id,  :if=>lambda{|s| s.country && s.country.admin?}  #only 1 state per admin country
  validates_presence_of :name,:abbrev, :country
  validates_uniqueness_of :name,:abbrev, :scope=>:country_id


end
