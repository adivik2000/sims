# == Schema Information
# Schema version: 20081111204313
#
# Table name: principal_overrides
#
#  id                 :integer         not null, primary key
#  teacher_id         :integer
#  student_id         :integer
#  principal_id       :integer
#  status             :integer
#  start_tier_id      :integer
#  end_tier_id        :integer
#  principal_response :string(1024)
#  teacher_request    :string(1024)
#  created_at         :datetime
#  updated_at         :datetime
#

class PrincipalOverride < ActiveRecord::Base
  belongs_to :teacher, :class_name => 'User'
  belongs_to :principal, :class_name =>'User'
  belongs_to :start_tier, :class_name => 'Tier'
  belongs_to :end_tier, :class_name => 'Tier'
  belongs_to :student

  STATUS=["Awaiting approval","Approved","Rejected*","Rejected","Approved*"]

  NEW_REQUEST=0
  APPROVED_SEEN=1
  REJECTED_NOT_SEEN =2
  REJECTED_SEEN = 3

  validates_presence_of :teacher_request, :message => "reason must be provided"
  after_create :email_principals

  protected

  def after_initialize
    self.start_tier = student.max_tier if start_tier.blank?

  end


  def email_principals
    Notifications.deliver_principal_override_request(self)
  end




end