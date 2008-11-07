Feature: Search By Student Groups
  In order to pick students to manage
  A SIMS user
  Should be able to find students by Student Group criteria

  Scenario: User With One Group
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd"
    And group "Red Team" for school "Central" with student "Red Fred"
    And I have access to "Blue Team"
    And I am on search page

    # And I should see my own username in the group member selection
    # And group_member_selection_id drop down should contain ["Prompt", "Option 1", "Option 2"]
    # And user_id drop down should contain ["default_user"]
    # And I should see select box with id of "search_criteria_user_id" and contains ['First Last']
    And I should see select box with id of "search_criteria_group_id" and contains ['Blue Team']

    # Then I should see Blue Team selection option
    # And I should not see Red team selection option
    When I select "Blue Team" from "Student Group"
    And I press "Search for Students"

    Then I should see "Floyd, Blue"
    And I should not see "Fred, Red"

  Scenario User With Two Groups Picks One
    Given school "West High"
    And group "Orange Team" for school "West High" with student "Alfie Orange"
    And group "Maroon Team" for school "West High" with student "Harold Yerbie"
    And I have access to "Orange Team"
    And I have access to "Maroon Team"
    And I am on search page
    And I should see select box with id of "search_criteria_group_id" and contains ['Filter by Group','Orange Team', 'Maroon Team']
    When I select "Orange Team" from "Student Group"
    And I press "Search for Students"
    Then I should see "Orange, Alfie"
    And I should not see "Yerbie, Harold"

#test student group dropdown
# 0 all (2 exist) groups available to user (show * + 2 options in dropdown)   should be able to see ungrouped
# 1 group available to user (user with one group above) should not beable to see ungrouped   readonly
# 2 groups available to user (choose) show * as well should not be able t osee ungrouped, but should be able to pick all their groups 


#general policy dropdowns, don't allow users to choose if they have no choice, or the choices have no difference
# 


# Scenarios -- group member
# 
#   -- one group user
#   group member has 1 row,     it should possibly be disabled
#           student groups should be assigned to that group member
# 
#   -- two+ groups user not all groups
#     group member has >1 rows,  it should also have a * to represent all available groups for that user
#           student groups should be the superset of listed groups
# 
# 
#   -- all group user
#       group member should have all users explicitly assigned to groups for school, should have * to represent all school groups.
#       student groups should be all in school.
# 
# 
#    user has access to no groups
#       ???  it should do something else maybe prompt them to add a group or contact support
#       
#   In both cases, the * represents all the user's groups,   which will be determined through the model and special groups.
#   
# 
# 
# student groups
#     * should be all groups available to member and only present if student groups has more than one


# other scenario all students by grade in school
#   should be empty or * if only explicit group available
#   otherwise explicit groups (with *)
