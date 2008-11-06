# == Schema Information
# Schema version: 20081030035908
#
# Table name: users
#
#  id           :integer         not null, primary key
#  username     :string(255)
#  passwordhash :binary
#  first_name   :string(255)
#  last_name    :string(255)
#  district_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class User < ActiveRecord::Base
  belongs_to :district
  has_and_belongs_to_many :schools
  has_many :special_user_groups
  has_many :user_group_assignments
  has_many :groups, :through=> :user_group_assignments


  def authorized_groups
    #TODO combine special user groups and user_group_assignments
    groups
  end

  def authorized_students
    #TODO combine special user groups and students through groups

  end

  validates_presence_of :username, :passwordhash, :last_name, :first_name
  validates_uniqueness_of :username, :scope=>:district_id


  def authorized_schools
    if special_user_groups.all_schools_in_district.find_by_district_id(self.district_id)
      district.schools
    else
      schools
    end

  end

  def self.authenticate(username, password)
		@user = self.find_by_username(username)
       
		if @user
			expected_password=encrypted_password(password)
			if @user.passwordhash != expected_password
         @user = nil unless ENV["RAILS_ENV"] =="development" || ENV["SKIP_PASSWORD"]=="skip-password"
			end
			@user
		end
	end

	def self.encrypted_password(password)
		Digest::SHA1.hexdigest(password.downcase)
	end

   
	def fullname 
		first_name.to_s + ' ' + last_name.to_s
  end

	def fullname_last_first
		last_name.to_s + ', ' + first_name.to_s
	end

  def has_group_for_school school
    has_group = groups.collect{|g| g.school}.include? school
    has_group
  end
end