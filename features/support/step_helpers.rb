def go_to_page page_name
  page_name = page_name.sub(/^the /i, '').sub(/ page$/i, '')

  if page_name == 'home'
    visit '/'
  else
    log_in
    # flunk page.body
    click_link 'School Selection' if page.body.include?('School Selection')

    page_name = page_name.sub(/^the /i, '').sub(/ page$/i, '')

    case page_name
    when 'search'
      click_button 'Choose School' unless page.body.include?("Default School has been automatically selected.")
      puts page.body unless page.body.include?('Search')
    when 'school selection'
    when 'new role'
    when 'student profile'
      # search
      unless page.body.include?("Default School has been automatically selected.")
        select("Default School")
        click_button "Choose School"
      end
      click_button "Search for Students"
      click_all_name_id_brackets
      click_button "select for problem solving"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path"
    end
  end
end

def click_all_name_id_brackets
  doc=Hpricot(page.body)
  doc.search("//input[@name='id[]']").each do |elem|
    check(elem[:id])
  end
end

def verify_select_box id, options
  options=Array(eval(options))
  page.should have_dropdown(id, options)
end

def log_in
  default_user
  create_school 'Default School' unless @additional_student
  visit '/'
  fill_in 'Login', :with => @default_user.username
  fill_in 'Password', :with => @default_user.username
  click_button 'Login'
  
  if page.body.include?("Please Login")
    set_headers({"HTTP_X_HTTP_METHOD_OVERRIDE"=>"POST"})
    set_headers({"REQUEST_METHOD"=>"POST"})
    click_button 'Login'
    set_headers({"HTTP_X_HTTP_METHOD_OVERRIDE"=>nil})
    set_headers({"REQUEST_METHOD"=>nil})
  end

  save_and_open_page if page.body.include?("Please Login")
  page.should_not have_text(/Authentication Failure/)
  page.should_not have_text(/Please Login/)
end

def find_or_create_user user_name
  default_district.users.find_by_username(user_name) || create_user(user_name)
end

def create_user user_name='first_last', password=user_name
  @user=Factory :user, :username => user_name,
    :first_name => user_name.split("_").first || 'First',
    :last_name => user_name.split("_").last || 'Last',
    :password=> password,
    :district_id => default_district.id
    
end

def create_school school_name
  found = School.find_by_name(school_name)
  s = found || Factory(:school,:name => school_name, :district_id => default_district.id)
  default_user.schools << s unless default_user.schools.include?(s)
  @school||=s
  s
end

def grant_access user_name, group_array
  user = find_or_create_user user_name

  groups = Array(eval(group_array))
  groups.each do |group_title|
    group = Group.find_by_title(group_title)
    user.user_school_assignments.create!(:school_id => group.school_id)
    raise "Missing group: '#{group_title}'" if group.nil?
    UserGroupAssignment.create!(:user => user, :group => group)
  end
end

def find_student first_name, last_name
  Student.find(:first, :conditions => {:first_name => first_name, :last_name => last_name})
end

def create_student first_name, last_name, grade, school, flag_type = nil, ignore_type = nil, ignore_reason = nil
  s = Factory(:student, :first_name => first_name, :last_name => last_name, :district_id => default_district.id)
  # :grade => grade
  enrollment = s.enrollments.create! :grade => grade, :school => school

  if flag_type
    f = SystemFlag.create!(:student => s,
      :category => flag_type,
      :reason => 'some reason or another',
      :user => @default_user)
  end

  if ignore_type and ignore_reason
    i = IgnoreFlag.create!(:student => s,
      :category => ignore_type,
      :reason => ignore_reason,
      :user => @default_user)
  end
  s
end

def create_default_student
  @student ||= create_student "Common", "Last", "04", @school
  g=Factory(:group,:title=>"Default Group", :school=>@school)
  g.students << @student
  g.save!
  @default_user.groups << g
  @default_user.save!

  @default_user.special_user_groups.create!(:grouptype=>SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL,:school_id=>@school.id, :district => @student.district)

  @student
end

def create_default_intervention_pieces
  g1=@district.goal_definitions.create!(:title=>"Some Goal",:description=>"whatever")
  @district.goal_definitions.create!(:title=>"Goal 1",:description=>"whatever2")
  o1=g1.objective_definitions.create!(:title=>"Some Objective",:description=>"whatever")
  g1.objective_definitions.create!(:title=>"Other Objective",:description=>"whatever")
  c1=o1.intervention_clusters.create!(:title=>"Some Category",:description=>"whatever")
  o1.intervention_clusters.create!(:title=>"Other Category",:description=>"whatever")
  d1=Factory(:intervention_definition,:title=>"Other Definition",:intervention_cluster => c1)
  TimeLength.destroy_all
  TimeLength.create!(:title=>"Default",:days=>90)
  Frequency.create!(:title=>"Default")
  @district.tiers.create!(:title=>"Default")
  @district.tiers.create!(:title=>"Some Tier")
end

def clear_login_dropdowns
 system("mysqldump --add-drop-table --no-data sims_open_test | mysql sims_open_test")
 @default_district=nil
end

private

def default_user
#  clear_login_dropdowns unless @default_user
  @default_user ||= create_user 'default_user'
  @default_user.roles = ['regular_user']
  @default_user.save!

  SpecialUserGroup.delete_all unless @additional_student
  # put other stuff above this
  @default_user
end

def default_district
  @default_district ||= Factory(:district)
end
