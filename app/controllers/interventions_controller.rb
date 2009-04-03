class InterventionsController < ApplicationController
  additional_write_actions 'end', 'quicklist', 'quicklist_options', 'ajax_probe_assignment', 'undo_end'
  before_filter :find_intervention, :only => [:show, :edit, :update, :end, :destroy, :undo_end]

  include PopulateInterventionDropdowns

  # GET /interventions/1
  def show
    @intervention_probe_assignment = @intervention.intervention_probe_assignments.first
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /interventions/new
  def new
    flash.keep(:custom_intervention)
    flash[:custom_intervention] ||= params[:custom_intervention]
    @quicklist = true if params[:quicklist]

    respond_to do |format|
      format.html { populate_goals }# new.html.erb
    end
  end

  # GET /interventions/1/edit
  def edit
    @recommended_monitors = @intervention.intervention_definition.recommended_monitors_with_custom.select(&:probe_definition)
    @intervention_probe_assignment = @intervention.intervention_probe_assignment 
    @users = current_school.users.collect{|e| [e.fullname, e.id]}
  end

  # POST /interventions
  def create
    @intervention = build_from_session_and_params

    if @intervention.save
      flash[:notice] = "Intervention was successfully created. #{@intervention.autoassign_message} "
      redirect_to(student_url(current_student, :tn=>0, :ep=>0))
    else
      #This is to make validation work
      i=@intervention
      @goal_definition = @intervention.goal_definition
      @objective_definition=@intervention.objective_definition
      @intervention_cluster = @intervention.intervention_cluster
      @intervention_definition = @intervention.intervention_definition
      populate_goals
      @intervention=i
      #end code to make validation work
      render :action => "new"
    end       
  end

  # PUT /interventions/1
  def update
    params[:intervention][:participant_user_ids] ||=[] if params[:intervention]
    params[:intervention][:intervention_probe_assignment] ||= {} if params[:intervention]
    respond_to do |format|
      if @intervention.update_attributes(params[:intervention])
        flash[:notice] = 'Intervention was successfully updated.'
        format.html { redirect_to(student_url(current_student, :tn=>0, :ep=>0)) }
      else
        format.html { edit and render :action => "edit" }
      end
    end
  end

  # DELETE /interventions/1
  def destroy
    logger.info("DELETION- #{current_user} at #{current_user.district} removed #{@intervention.title} from #{current_student}")
    @intervention.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end

  def end
    @intervention.end(current_user.id)
     respond_to do |format|
      format.html { redirect_to(current_student) }
    end
  end

  def undo_end
    
    @intervention.undo_end
    redirect_to current_student
  end


  def quicklist_options
    @quicklist_intervention_definitions = current_school.quicklist 
    respond_to do |format|
      format.js
      format.html
    end
  end

  def quicklist #post
    #FIXME scope this somehow
    @intervention_definition = InterventionDefinition.find_by_id(params[:quicklist_item][:intervention_definition_id])
    redirect_to :back and return if @intervention_definition.blank?
    @intervention_cluster = @intervention_definition.intervention_cluster
    @objective_definition = @intervention_cluster.objective_definition
    @goal_definition = @objective_definition.goal_definition

    redirect_to new_intervention_url(:goal_id=>@goal_definition,:objective_id=>@objective_definition,
           :category_id=>@intervention_cluster,:definition_id=>@intervention_definition, :quicklist=>true)
  end

  def ajax_probe_assignment
    flash.keep(:custom_intervention)
    @intervention = current_student.interventions.find_by_id(params[:intervention_id]) || Intervention.new
    @intervention_probe_assignment = @intervention.intervention_probe_assignments.find_by_probe_definition_id(params[:id]) if @intervention
    unless @intervention_probe_assignment
      rec_mon = RecommendedMonitor.find_by_probe_definition_id(params[:id])
      @intervention_probe_assignment = rec_mon.build_intervention_probe_assignment if rec_mon
    end
    render :partial => 'interventions/probe_assignments/intervention_probe_assignment_detail'
  end
  private

  def find_intervention
    if current_student.blank?
     #alternate entry point
      intervention = Intervention.find_by_id(params[:id])
      if intervention && intervention.student && intervention.student.belongs_to_user?(current_user)
        student=intervention.student
        session[:school_id] = (student.schools & current_user.schools).first.id
        session[:selected_student]=student.id
        session[:selected_students]=[student.id]
        @intervention = intervention
      else
        flash[:notice] = 'Intervention not available'
        redirect_to logout_url and return false
      end
    else
      @intervention = current_student.interventions.find_by_id(params[:id])
    end

    unless @intervention
      flash[:notice] = "Intervention could not be found"
      redirect_to current_student and return false
    end
  end
end
