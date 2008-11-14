class StudentsController < ApplicationController
	before_filter :enforce_session_selections, :except => [:index, :select, :search, :new, :create]
  additional_read_actions %w{grade_search member_search search}

  # GET /students
  # GET /students.xml
  def index
    @students = student_search

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  def select
    # add selected students to session, then redirect to show
    
    @students = student_search
    authorized_student_ids = @students.collect {|s| s.student.id.to_s}

    if params[:id].blank?
      flash[:notice] = 'No students selected'
    # elsif authorized_student_ids.to_set.subset?(params[:id].to_set)
    elsif params[:id].to_set.subset?(authorized_student_ids.to_set)
      session[:selected_students] = params[:id]
      session[:selected_student] = session[:selected_students].first
      redirect_to student_url(session[:selected_student]) and return
    else
      flash[:notice] = 'Unauthorized Student selected'
    end
    session[:selected_students]= nil
    session[:selected_student]= nil
    render :action=>"index" 
  end

  def search
    if request.get?
      @grades = current_school.grades_by_user(current_user)
      flash[:notice] = "User doesn't have access to any students at #{current_school.name}" and redirect_to schools_url and return if @grades.blank?
 
      @groups=current_user.filtered_groups_by_school(current_school)
      @users=current_user.filtered_members_by_school(current_school)
   else
      if params['search_criteria']
        session[:search] = params['search_criteria'] ||{}
        session[:search]['flagged_intervention_types'] = params['flagged_intervention_types']
        session[:search]['intervention_group_types'] = params['intervention_group_types']
        session[:search][:intervention_group] = current_district.search_intervention_by.class_name if session[:search][:intervention_group_types]
        redirect_to students_url
      else
        flash[:notice] = 'Missing search criteria'
        redirect_to :action => :search
      end
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = current_school.students.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end


  #RJS methods for search page

  def grade_search
    @users=current_user.filtered_members_by_school(current_school,params)
    @groups=current_user.filtered_groups_by_school(current_school,params)

  end
 
  def member_search
    @groups=current_user.filtered_groups_by_school(current_school,params)
  end

 

  private
  def enforce_session_selections
    return true unless params[:id]
		# raise "I'm here" if selected_students_ids.nil?
    if selected_students_ids and selected_students_ids.include?(params[:id])
      session[:selected_student]=params[:id]
      return true
    else
      flash[:notice]='Student not selected'
      redirect_to students_url and return false
    end
  end


  def student_search
    current_user.authorized_enrollments_for_school(current_school).search(session[:search])
  end



end
