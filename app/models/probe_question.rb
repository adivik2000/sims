# == Schema Information
# Schema version: 20101027022939
#
# Table name: probe_questions
#
#  id                  :integer(4)      not null, primary key
#  probe_definition_id :integer(4)
#  number              :integer(4)
#  operator            :string(255)
#  first_digit         :integer(4)
#  second_digit        :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class ProbeQuestion < ActiveRecord::Base
  belongs_to :probe_definition
  has_and_belongs_to_many :probes

  def self.find_questions_for_report(assessment_type, intervention_probe_definition)
    #I'm not sure what this is yet
    if assessment_type=='baseline'
      intervention_probe_definition.probe_definition.probe_question_definitions

    elsif assessment_type=='update'
      previous_probe=intervention_probe_definition.probes_for_graph.find(:first)
      questions=previous_probe.probe_question_definitions
    end
    questions
  end


end
