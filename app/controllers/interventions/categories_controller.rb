class Interventions::CategoriesController < ApplicationController
  def show
  end

  def index
    @goal_definition=current_district.goal_definitions.find(params[:goal_id])
    @objective_definitions=@goal_definition.objective_definitions
    @objective_definition=@goal_definition.objective_definitions.find(params[:objective_id])
    @goal_definitions=current_district.goal_definitions #not for js
    @intervention_clusters = @objective_definition.intervention_clusters
  end

  def select
    redirect_to interventions_definitions_url(params[:goal_id],params[:objective_id],params[:intervention_cluster][:id])
  end

end


