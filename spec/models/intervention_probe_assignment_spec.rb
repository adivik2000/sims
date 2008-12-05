# == Schema Information
# Schema version: 20081125030310
#
# Table name: intervention_probe_assignments
#
#  id                   :integer         not null, primary key
#  intervention_id      :integer
#  probe_definition_id  :integer
#  frequency_multiplier :integer
#  frequency_id         :integer
#  first_date           :datetime
#  end_date             :datetime
#  enabled              :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionProbeAssignment do
  before(:each) do
    @valid_attributes = {
      :frequency_multiplier => "1",
      :first_date => Time.now,
      :end_date => Time.now,
      :enabled => false
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionProbeAssignment.create!(@valid_attributes)
  end
end
