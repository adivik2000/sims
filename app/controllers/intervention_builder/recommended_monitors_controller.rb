class InterventionBuilder::RecommendedMonitorsController < ApplicationController
  additional_write_actions %w{move assign_probes_to_intervention assign_interventions_to_probe}
  additional_read_actions 'move_path'

  helper_method :move_path
  def assign_probes_to_intervention
    
    @intervention_definition=current_district.find_intervention_definition_by_id(params[:id])
    @back_path =  intervention_builder_intervention_url(*@intervention_definition.ancestor_ids)
  
    if request.post? and params[:commit]
      flash[:notice=] = "Changes saved for #{@intervention_definition.title}" if @intervention_definition.probe_definition_ids=params[:probes]
      redirect_to @back_path and return        
    end
    @recommended_monitors = @intervention_definition.recommended_monitors.collect(&:probe_definition_id)
    @probe_definitions_in_groups =  current_district.probe_definitions.group_by_cluster_and_objective
 
  end

  def assign_interventions_to_probe
    @probe_definition=current_district.probe_definitions.find(params[:id])
  
    if request.post? and params[:commit]
      flash[:notice=] = "Changes saved for #{@probe_definition.title}" if @probe_definition.intervention_definition_ids=params[:int_defs]
      redirect_to intervention_builder_probes_url and return        
    end
    @recommended_monitors = @probe_definition.recommended_monitors.collect(&    :intervention_definition_id)
    @goal_definitions=current_district.goal_definitions.find(:all,:include=>{:objective_definitions=>{:intervention_clusters=>:intervention_definitions}})
  end
 
  def move
    @recommended_monitor = current_district.recommended_monitors.find(params[:id])

    if params[:direction]
      @recommended_monitor.move_higher if params[:direction].to_s == "up"
      @recommended_monitor.move_lower if params[:direction].to_s == "down"
    end
    respond_to do |format|
      format.html {redirect_to intervention_bulder_intervention_url(
        *@recommended_monitor.intervention_definition.ancestor_ids)}
      format.js {@recommended_monitors=@recommended_monitor.intervention_definition.recommended_monitors} 
    end
  end

  def move_path(item, direction)
     url_for(:controller=>"recommended_monitors",:action=>:move,:direction=>direction,:id=>item)
  end




end

