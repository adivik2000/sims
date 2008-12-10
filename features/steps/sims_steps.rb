require File.dirname(__FILE__)+'/step_helpers'
require File.dirname(__FILE__)+'/require_everything'


Given /^common data$/i do
  District.destroy_all and State.destroy_all and Country.destroy_all
  @district=Factory(:district)
  @school=Factory(:school,:district=>@district, :name=>"Default School")
  @default_user = create_user
  @default_user.district=@district
  @default_user.save!
  create_default_student
  @student.district=@district
  @student.save!
  create_default_intervention_pieces
end

Given /^user "(.*)" with password "(.*)" exists$/ do |user_name, password|
     District.destroy_all and State.destroy_all and Country.destroy_all
	create_user user_name, password
end

Given /^I am a district admin$/ do
   District.destroy_all and State.destroy_all and Country.destroy_all
  default_user
  log_in
  role = Role.create!(:name => "District Admin", :district_id => 1)
  role.rights.create!(:controller=>"roles", :read=>true, :write=>true)
  default_user.roles=[role]
  
end

When /^I go to (.*)$/ do |page_name|
	go_to_page page_name
end

When /^I am on (.*)$/ do |page_name|
	go_to_page page_name
end

Given /^"(.*)" has access to (.*)$/ do |user_name, group_array|
  grant_access user_name, group_array
end

# TODO: combine with above method...
Given /^I have access to (.*)$/ do |group_array|
  grant_access 'default_user', group_array
end

Given /^student "(.*)" "(.*)" in grade (\d+) at "(.*)" with "(.*)" flag$/ do |first, last, student_grade, school_name, flag_type|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school, flag_type
end

Given /^student "(.*)" "(.*)" in grade (\d+) at "(.*)"$/ do |first, last, student_grade, school_name|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school
end

# # use this if you want the default user to belong to a group for the school
# Given /^accessible school "(.*)"$/ do |school_name|
#   s = create_school school_name
#   group = Group.create!(:title => "Default Group for #{school_name}", :school => s)
#   UserGroupAssignment.create!(:user => default_user, :group => group)
# end

Given /^school "(.*)"$/ do |school_name|
	create_school school_name
end

Then /^I should see select box with id of "(.*)" and contains (.*)$/ do |id, options|
  verify_select_box id, options
end

Given /group "(.*)" for school "([^\"]*)"$/ do |group_title, school_name|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)
end

Given /group "(.*)" for school "(.*)" with student "([^\"]*)"$/ do |group_title, school_name, student_name|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)
  first,last=student_name.split(" ")
  student = create_student(first,last, '1', school)
  group.students << student
end

# TODO: extract helper
Given /group "(.*)" for school "(.*)" with student "([^\"]*)" in grade "(.*)"$/ do |group_title, school_name, student_name, grade|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)
  first,last=student_name.split(" ")
  student = create_student(first,last, grade, school)
  group.students << student
end

Given /group "(.*)" for school "(.*)" with students (.*)$/ do |group_title, school_name, students_array|
  school = School.find_by_name(school_name)
  group = Group.create!(:title => group_title, :school => school)

  students = Array(eval(students_array))
  students.each do |student_name|
    first, last = student_name.split(" ")
    student = find_student(first, last) || create_student(first,last, '1', school)
    group.students << student
  end
end

Given /^require everything$/ do
  #only called once
  require_everything_in_app
end

Given /^load demo data$/ do
  fixtures_dir = File.expand_path(RAILS_ROOT)+ '/test/fixtures'

  Fixtures.reset_cache
  Dir.entries(fixtures_dir).select{|e| e.include?"yml"}.each do |f|
    Fixtures.create_fixtures(fixtures_dir, File.basename("#{f}", '.*'))
  end

end

Then "^I Display Body$" do
  puts response.body
end

When /^I should click js "all"$/ do 
  click_all_name_id_brackets
end

# Given /^I should see javascript code that will do xhr for "search_criteria_grade" that updates ["search_criteria_user_id", "search_criteria_group_id"]$/ do
Given /^I should see javascript code that will do xhr for "(.*)" that updates (.*)$/ do |observed_field, target_fields|
  response.body.should match(/Form.Element.EventObserver\('#{observed_field}'/)
end

# When /^xhr "search_criteria_user_id" updates ["search_criteria_group_id"]
When /^xhr "(.*)" updates (.*)$/ do |observed_field, target_fields|
  user=User.find_by_username("default_user")
  other_guy=User.find_by_username("Other_Guy")
  school=School.find_by_name("Central")
 
  if observed_field == "search_criteria_grade"
    xml_http_request  :post, "/students/grade_search/", {:grade=>3}, {:user_id => user.id, :school_id=>school.id}
  elsif observed_field == "search_criteria_user_id"
    xml_http_request  :post, "/students/member_search/", {:grade=>3,:user=>other_guy.id}, {:user_id => user.id, :school_id=>school.id}
  else
    flunk response.body
  end
    
  Array(eval(target_fields)).each do |target_field|
    response.body.should match(/Element.update\("#{target_field}"/)
  end
  #  response.should hav_text /"<option value=\"996332878\">default user</option>");"/
  
end

Then /^I should verify rjs has options (.*)$/ do |options|
  response.should have_options(Array(eval(options)))
end

Given /^I enter URL "(.*)"$/ do |url|
  visits url
end
