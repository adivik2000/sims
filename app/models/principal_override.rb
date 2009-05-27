# == Schema Information
# Schema version: 20090524185436
#
# Table name: principal_overrides
#
#  id                 :integer         not null, primary key
#  teacher_id         :integer
#  student_id         :integer
#  principal_id       :integer
#  status             :integer         default(0)
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
  attr_accessor :action

  STATUS=["Awaiting approval","Approved","Rejected*","Rejected","Approved*"]

  NEW_REQUEST=0
  APPROVED_SEEN=1
  REJECTED_NOT_SEEN =2
  REJECTED_SEEN = 3
  APPROVED_NOT_SEEN =4


  validates_inclusion_of :action, :in =>['accept','reject'], :unless => Proc.new{|p| p.status == NEW_REQUEST} 
  validates_presence_of :teacher_request, :message => "reason must be provided"
  validates_presence_of :principal_response, :message => "Reason must be provided", :unless => Proc.new{|p| p.status == NEW_REQUEST}
  after_create :email_principals
  named_scope :pending, :conditions=>{:status=>NEW_REQUEST}
  named_scope :approved, :conditions=>{:status=>[APPROVED_SEEN,APPROVED_NOT_SEEN]}


  def self.pending_for_principal(user)
    pnd=pending.find(:all,:joins=>:student,   :conditions => {:students => {:district_id => user.district_id }})
    pnd.select do |p|
      !p.student.blank? && p.student.principals.include?(user) 
    end
  end

  def self.max_tier
    approved.collect(&:end_tier).compact.max
  end
  
  def setup_response_for_edit(action)
    #TODO Autoset to next or max tier

    self.action=action
    self.end_tier=self.start_tier

  end

  def status_text
    STATUS[self.status]
  end

  def undo!
    self.principal=nil
    self.principal_response=nil
    self.end_tier=nil
    self.status=NEW_REQUEST
    self.action="undo"
    self.save!

  end

  protected

  def after_initialize
    self.start_tier = student.max_tier if start_tier.blank? and !student.blank?

  end


  def email_principals
    Notifications.deliver_principal_override_request(self)
  end

  def before_validation_on_update
    #TODO make sure the principal is actually a principal for this student
    #Refactor this
    @send_email=true
    case self.action
    when 'accept':
      self.status=APPROVED_NOT_SEEN
    when 'reject':
      self.status=REJECTED_NOT_SEEN
    when 'undo'
      @send_email=false
    else
      @send_email=false
      self.status=-1
    end
    true

  end

  def after_update
    Notifications.deliver_principal_override_response(self) if @send_email
  end


end
