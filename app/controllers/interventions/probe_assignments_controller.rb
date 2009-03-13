class Interventions::ProbeAssignmentsController < ApplicationController

  before_filter :load_intervention
  additional_write_actions  'disable_all'
  
  def index
    #need t odo something with probe definition id (that's the active one, and might need building)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment(params[:probe_definition_id])
    @intervention_probe_assignments = [@intervention_probe_assignment] | @intervention.intervention_probe_assignments

    respond_to do |format|
      format.js
      format.html # index.html.erb
    end
  end

  def disable_all
    @intervention.intervention_probe_assignments.each(&:disable)
    flash[:notice] = "All assigned monitors have been unassigned"

    respond_to do |format|
      format.html {redirect_to(@intervention)}
    end

  end

  protected
  def load_intervention
    @intervention ||=current_student.interventions.find(params[:intervention_id])
  end

end
