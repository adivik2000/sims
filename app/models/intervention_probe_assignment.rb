# == Schema Information
# Schema version: 20090623023153
#
# Table name: intervention_probe_assignments
#
#  id                   :integer(4)      not null, primary key
#  intervention_id      :integer(4)
#  probe_definition_id  :integer(4)
#  frequency_multiplier :integer(4)
#  frequency_id         :integer(4)
#  first_date           :date
#  end_date             :date
#  enabled              :boolean(1)
#  created_at           :datetime
#  updated_at           :datetime
#

class InterventionProbeAssignment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency
  has_many :probes, :dependent => :destroy

  delegate :title, :to => :probe_definition
  delegate :student, :to => :intervention
  validates_associated :probes #,:probe_definition
  validate :last_date_must_be_after_first_date

  accepts_nested_attributes_for :probe_definition

  RECOMMENDED_FREQUENCY = 2

#  validates_date :first_date, :end_date

  named_scope :active, :conditions => {:enabled=>true}


  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(:enabled=>false)
  end

  def student_grade
    #TODO delegate this
    student.enrollments.first.grade
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency}"
  end

  def valid_score_range
    "#{probe_definition.minimum_score} - #{probe_definition.maximum_score}"
  end

  def new_probes=(params)
    params=params.values
    params.each do |param|
      @new_probe = probes.build(param) unless param['score'].blank?
    end
  end

  def to_param
    unless new_record?
      id
    else
      "pd#{probe_definition_id}"
    end
  end
  
  protected
  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

  def after_initialize
    self.frequency_multiplier=RECOMMENDED_FREQUENCY if self.frequency_multiplier.blank?
  end
end
