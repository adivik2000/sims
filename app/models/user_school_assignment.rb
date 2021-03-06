# == Schema Information
# Schema version: 20101101011500
#
# Table name: user_school_assignments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  user_id    :integer(4)
#  admin      :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class UserSchoolAssignment < ActiveRecord::Base
  belongs_to :school
  belongs_to :user

  # Need to be able to create these before assigning them to a parent...
  # validates_presence_of :school_id
  # validates_presence_of :user_id

  named_scope :admin, :conditions => {:admin => true}
  named_scope :non_admin, :conditions => {:admin => false}
  after_save :create_all_students
  after_destroy :remove_special_user_groups

  def all_students
    !!user.special_user_groups.find_by_school_id_and_grade_and_grouptype(school_id, nil, SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL) if user
  end

  def all_students=(val)
    if val =="true"
      @all_students=true

    elsif val == "false"
      @all_students=false
    end

  end

private
  def remove_special_user_groups
    SpecialUserGroup.delete_all("user_id = #{user_id} and school_id = #{school_id}")
  end

  def create_all_students
    if @all_students
      d=user.special_user_groups.find_or_create_by_school_id_and_grade_and_grouptype_and_district_id(school_id,nil,SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL,user.district_id) 

    elsif @all_students ==false
     user.special_user_groups.find_all_by_school_id_and_grade_and_grouptype(school_id, nil, SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL).each(&:destroy)
    end

  end

end
