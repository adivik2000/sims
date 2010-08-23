When /^I log in with basic auth as "([^"]*)" with password "([^"]*)"$/ do |username, password|
  basic_auth(username, password)
end

When /^I enter url "([^"]*)" with abbrev$/ do |url|
  visit "#{url}?district_abbrev=#{@user.district.abbrev}"
end



Given /^a user "([^"]*)"$/ do |username|
  @user = User.find_by_username(username) || Factory(:user,:username=>username,:email => "#{username}@example.com",:password=>'e')
end

Given /^a student with district_student_id "([^"]*)"$/ do |id|
  stu=Factory(:student,:district_id => @user.district_id).update_attribute(:district_student_id,id)
end

Given /^an intervention_definition with id "([^"]*)"$/ do |id|
  InterventionDefinition.delete_all
  int_def = Factory(:intervention_definition, :title => 'cuke1', :description => 'cuke1' )
  InterventionDefinition.update_all("id = #{id}", "id = #{int_def.id}")
  GoalDefinition.update_all("district_id = #{@user.district_id}")
end
