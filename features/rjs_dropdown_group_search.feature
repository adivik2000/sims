Feature: Search By Student Groups
  In order to filter student groups and members
  A SIMS user
  Should be able to change the lower dropdowns when upper ones are changed

  Scenario: User With Two Groups  changes grade
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd" in grade "1"
    And group "Red Team" for school "Central" with student "Red Fred" in grade "3"
    And I have access to ["Blue Team","Red Team"]
    And "Other_Guy" has access to ["Blue Team"]
    And I am on search page

    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group","Blue Team", "Red Team"]
    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","default user", "Other Guy"]
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3"]

    And I should see javascript code that will do xhr for "search_criteria_grade" that updates ["search_criteria_user_id", "search_criteria_group_id"]
    
    When I select "3" from "search_criteria_grade"
    #would be nice to pull the value from webrat or cucumberm but we might need to specify it again explicitly
   
    And xhr "search_criteria_grade" updates ["search_criteria_group_id", "search_criteria_user_id"]  
    #And rjs is triggered for "grade" and value "3"
  
    Then I should verify rjs has options ["default user", "Red Team"]



  Scenario: User with two groups, changes member
    Given school "Central"
    And group "Blue Team" for school "Central" with student "Blue Floyd" in grade "1"
    And group "Red Team" for school "Central" with student "Red Fred" in grade "3"
    And I have access to ["Blue Team","Red Team"]
    And "Other_Guy" has access to ["Blue Team"]
    And I am on search page
    
    And I should see select box with id of "search_criteria_group_id" and contains ["Filter by Group","Blue Team", "Red Team"]
    And I should see select box with id of "search_criteria_user_id" and contains ["Filter by Group Member","default user", "Other Guy"]
    And I should see select box with id of "search_criteria_grade" and contains ["*", "1", "3"]

    And I should see javascript code that will do xhr for "search_criteria_user_id" that updates ["search_criteria_group_id"]
    
    When I select "Other Guy" from "search_criteria_user_id"
    And xhr "search_criteria_user_id" updates ["search_criteria_group_id"]  
    Then I should verify rjs has options ["Red Team"]



