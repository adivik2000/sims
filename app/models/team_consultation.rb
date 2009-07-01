# == Schema Information
# Schema version: 20090623023153
#
# Table name: team_consultations
#
#  id           :integer(4)      not null, primary key
#  student_id   :integer(4)
#  requestor_id :integer(4)
#  recipient_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class TeamConsultation < ActiveRecord::Base
  belongs_to :student
  belongs_to :requestor, :class_name =>'User'
  belongs_to :school_team, :foreign_key => 'team_id'
  has_one :consultation_form, :dependent => :destroy
  
  delegate :district,  :to => '(student or team_consultation or return nil)'
  accepts_nested_attributes_for :consultation_form

  after_create :email_concern_recipient

  def email_concern_recipient
    if student && requestor
      TeamReferrals.deliver_concern_note_created(self)
    end
  end

  def recipient
    User.find(school_team.contact)
  end
end
