Feature: Scrited Interaction with SIMS
  In order to allow automated interaction with SIMS
  A SIMS DISTRICT ADMIN
  Should be able to upload and download a file using curl

  Scenario: Automated Intervention
    Given a user "automated_intervention"
    When I log in with basic auth as "automated_intervention" with password "e"
    And I enter url "/scripted/automated_intervention" with abbrev
    Then I should see "Upload a file with the following headers"
    Then I should see "You can also automate this using curl"

    When I attach the file "test/csv/automated_intervention/sample.csv" to "upload_file"
    And I press "Submit"

    And I am pending
#This is problematic to test because the emails are in a separate process.  
#    When I upload the automated_intervention sample file using curl
#    Then I should receive an email
#    When I open the email
#    Then I should see "1 intervention added" in the email

