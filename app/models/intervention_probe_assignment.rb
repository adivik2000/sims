class InterventionProbeAssignment < ActiveRecord::Base
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency

  RECOMMENDED_FREQUENCY=2

  validates_date :first_date, :end_date

  validate :last_date_must_be_after_first_date


  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(:disabled=>true)
  end


  protected
  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

end