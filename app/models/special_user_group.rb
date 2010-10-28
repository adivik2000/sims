# == Schema Information
# Schema version: 20101027022939
#
# Table name: special_user_groups
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  district_id  :integer(4)
#  school_id    :integer(4)
#  grouptype    :integer(4)
#  grade        :string(255)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class SpecialUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :district
  belongs_to :school

  #other fields, grade, grouptype, is_principal
  #temporary list of grouptypes for now there's also a grade field
  ALL_SCHOOLS_IN_DISTRICT=1  #not going to fully implement this yet
  ALL_STUDENTS_IN_DISTRICT =2
  ALL_STUDENTS_IN_SCHOOL = 3

  validates_presence_of :grouptype, :user_id
  validates_presence_of :district_id #, :if => lambda {|s| s.school_id.blank?}
  validates_presence_of :school_id, :if => lambda {|s| s.district_id.blank?}
  validates_uniqueness_of :user_id, :scope=>[:grade,:district_id,:school_id,:grouptype] , :message => "-- Remove the user first." 


  named_scope :principal,:conditions=>{:is_principal=>true}
  named_scope :all_schools_in_district ,:conditions=>{:grouptype=>[ALL_SCHOOLS_IN_DISTRICT,ALL_STUDENTS_IN_DISTRICT]}
  named_scope :all_students_in_school ,lambda { |*args| {:conditions=>["grouptype=? or (grouptype = ? and grade is null and school_id = ?) ",ALL_STUDENTS_IN_DISTRICT, ALL_STUDENTS_IN_SCHOOL,  args.first]}}
  named_scope :all_students_in_district, :conditions =>{:grouptype=>ALL_STUDENTS_IN_DISTRICT}

  def self.all_students_in_school?(school)
    all_students_in_school(school).count > 0
  end

  def self.schools
    find(:all).collect(&:school).compact.flatten.uniq
  end
  
  def self.grades_for_school(school)
    find_all_by_grouptype_and_school_id(ALL_STUDENTS_IN_SCHOOL,school,:select=>"distinct grade", :conditions=>"grade is not null").collect(&:grade).uniq
  end

  def to_i
    #fixes ticket 152
    1
  end

end

