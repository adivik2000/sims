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
    controller = self.class.controller_path  #may need to change this
    action_group = action_group_for_current_action
    unless current_user.authorized_for?(controller,action_group)
      #log this
      puts "controller is #{controller} action_name is #{action_name} action_group is #{action_group}"
      
      flash[:notice] =  "You are not authorized to access that page"
      redirect_to root_url
      return false
    end
    true
  end

  
  DEFAULT_READ_ACTIONS = ['index', 'select', 'show', 'preview']
  DEFAULT_WRITE_ACTIONS =  ['create', 'update', 'destroy', 'new', 'edit', 'move', 'disable', 'disable_all', 'end', 'save_assessment','create_assessment', 'new_from_this', 'update_assessment', 'new_assessment']
  @@read_actions = Hash.new(DEFAULT_READ_ACTIONS)
  @@write_actions =Hash.new(DEFAULT_WRITE_ACTIONS)
  def action_group_for_current_action
    
    if @@write_actions[self.class.object_id].include?(action_name)
      'write'
    elsif @@read_actions[self.class.object_id].include?(action_name)
      #put in the defaults here,   override this and call super in individual controllers
      "read"
    else
      nil
    end
  end

  def self.show_read_actions
    puts "read actions are: #{@@read_actions.inspect}."
  end
 
  def self.additional_read_actions(*args)
     @@read_actions[self.object_id] = DEFAULT_READ_ACTIONS | Array(args).flatten.map(&:to_s)
  end

  def self.additional_write_actions(*args)
     @@write_actions[self.object_id] = DEFAULT_WRITE_ACTIONS | Array(args).flatten.map(&:to_s)
  end


end
