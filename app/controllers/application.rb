# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher

  helper :all # include all helpers, all the time
  helper_method :multiple_selected_students?, :selected_students_ids, 
    :current_student_id, :current_student, :current_district
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f94867ed424ccea84323251f7aa373db'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  #
  #
  before_filter :authenticate, :authorize

  
  private
  def current_user_id
    session[:user_id]
  end

  def current_user
    @user=User.find(current_user_id)
  end

  def selected_students_ids
    session[:selected_students]  
  end

  def multiple_selected_students?
    selected_students_ids and selected_students_ids.size > 1
  end

  def current_student_id
    session[:selected_student]
  end


  def current_student
    @student ||=Student.find(current_student_id)
  end

  def current_school_id
    session[:school_id]
  end

  def current_school
    @school ||= School.find(current_school_id)
  end

  def current_district_id
    nil
  end

  def current_district
    @@district ||= District.first || District.create!
  end

  def authenticate
    unless current_user_id
      flash[:notice] = "You must be logged in to reach that page"
      redirect_to root_url
      return false
    end
    true
  end

  def authorize
    return true

    controller=self.class.controller_path  #may need to change this
    action_group=action_group_for(action_name)
    unless current_user.authorized_for?(controller,action_group)
      flash[:notice] = "You are not authorized to access that page"
      redirect_to root_url
      return false
    end
    true

  end

  def action_group_for(n)
    #put in the defaults here,   override this and call super in individual controllers
    "read"
  end


end
