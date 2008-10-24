require File.dirname(__FILE__)+'/sims_step_helpers'

Given /user "(.*)" with password "(.*)" exists/ do |user_name, password|
	create_user user_name, password
end

When /^I go to (.*)$/ do |page_name|
	go_to_page page_name
end

Given /I am on the "(.*)" page/ do |page_name|
	go_to_page page_name
end

Given /student "(.*)" "(.*)" in grade (\d+) at "(.*)" with "(.*)" flag$/ do |first, last, student_grade, school_name, flag_type|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school, flag_type
end

Given /student "(.*)" "(.*)" in grade (\d+) at "(.*)"$/ do |first, last, student_grade, school_name|
	school = School.find_by_name(school_name)
	create_student first, last, student_grade, school
end

Given /school "(.*)"/ do |school_name|
	create_school school_name
end

Then /^I should see select box with "(.*)" and "(.*)"$/ do |option_1, option_2|
	response.should have_tag('select') do
		with_tag('option', :text => option_1)
		with_tag('option', :text => option_2)
	end
end
