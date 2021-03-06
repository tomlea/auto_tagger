Feature: Deployment
  In order to get auto-tagging goodness on ci boxes
  As a ruby and git ninja
  I want to be able to easily create a tag from the command line with the same name format as the one created by the cap tasks

  Scenario: user runs autotag with no args
    Given a repo
    When I run autotag with no arguments
    Then I should see "USAGE:"
    And no tags should be created
    
  Scenario: user runs autotag with "--help"
    Given a repo
    When I run autotag with "--help"
    Then I should see "USAGE:"
    And no tags should be created

  Scenario: user runs autotag with "-h"
    Given a repo
    When I run autotag with "-h"
    Then I should see "USAGE:"
    And no tags should be created

  Scenario: user runs autotag with "-?"
    Given a repo
    When I run autotag with "-?"
    Then I should see "USAGE:"
    And no tags should be created

  Scenario: user runs autotag with "demo"
    Given a repo
    When I run autotag with "demo"
    # can't check output here for some reason
    Then a "demo" tag should be created

  Scenario: user runs autotag with "demo ."
    Given a repo
    When I run autotag with "demo"
    Then a "demo" tag should be created
