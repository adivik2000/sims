cplass Interventions::ProbesController < ApplicationController
  before_filter :load_intervention,:load_intervention_probe_assignment, :except=>:index
  
  def index
    @intervention=current_student.interventions.find(params[:intervention_id],:include=>{:intervention_probe_assignments=>[:probe_definition,:probes]})
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    @probe = @intervention_probe_assignment.probes.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @probe = @intervention_probe_assignment.probes.find(params[:id])
  end

  def create
    @probe = @intervention_probe_assignment.probes.new(params[:probe])

    respond_to do |format|
      if @probe.save
        flash[:notice] = 'Score was successfully created.'
        format.html { redirect_to(@intervention) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @probe = @intervention_probe_assignment.probes.find(params[:id])

    respond_to do |format|
      if @probe.update_attributes(params[:probe])
        flash[:notice] = 'Probe was successfully updated.'
        format.html { redirect_to(@intervention) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @probe = @intervention_probe_assignment.probes.find(params[:id])
    @probe.destroy

    respond_to do |format|
      format.html { redirect_to(probes_url(@intervention,@intervention_probe_assignment)) }
    end
  end

  def new_assessment
    @probe = @intervention_probe_assignment.probes.new(:assessment_type=>:baseline)
    @questions = @probe.probe_definition.probe_questions
  end

  def update_assessment
    @probe = @intervention_probe_assignment.probes.new(:assessment_type=>:update)
    @questions = @intervention_probe_assignment.probes.last.probe_questions unless @intervention_probe_assignment.probes.blank?
  end

  def save_assessment

    @probe = @intervention_probe_assignment.probes.new(params[:probe])
    @probe.calculate_score(params)
    @probe.save!

    if params[:commit] == "Submit Without Printing"
      flash[:notice]="Assessment Score Saved"
      redirect_to(@intervention)
    elsif params[:commit] == "Submit And Print Results"
      print_results
      render :action=>"print_results"
    else
      raise "Invalid commit"
    end


  end


  protected
  def load_intervention
    @intervention=current_student.interventions.find(params[:intervention_id])
  end

  def load_intervention_probe_assignment
    @intervention_probe_assignment = @intervention.intervention_probe_assignments.find(params[:probe_assignment_id])
  end

  def print_results
    @questions=@probe.probe_questions
    @allquestions=@probe.probe_definition.probe_questions
    setup_report(@questions,@allquestions)
    

  end

  def setup_report(questions, allQuestions)
     diffQuestions = allQuestions - questions
       allQuestions.each do |question|
         if diffQuestions.include?(question)
           flash["answer_#{question.number}"] = question.first_digit + question.second_digit
         end
       end
  end

end
