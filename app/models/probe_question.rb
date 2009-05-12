# == Schema Information
# Schema version: 20090428193630
#
# Table name: probe_questions
#
#  id                  :integer         not null, primary key
#  probe_definition_id :integer
#  number              :integer
#  operator            :string(255)
#  first_digit         :integer
#  second_digit        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  copied_at           :datetime
#  copied_from         :integer
#

class ProbeQuestion < ActiveRecord::Base
  belongs_to :probe_definition
  has_and_belongs_to_many :probes
  is_paranoid
  include DeepClone

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


  private
  def deep_clone_parent_field
    'probe_definition_id'
  end

  def deep_clone_children
    []
  end



end
