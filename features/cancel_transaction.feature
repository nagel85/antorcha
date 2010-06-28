Feature: Cancel transaction
  In order stop colleagues from doing unnecessary work
  As a user
  I want to be able to cancel a transaction
  
  Scenario: Create a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    When I fill in "Title" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Create Transaction"
    Then I should see "Transaction was successfully created"

  Scenario: Cancel a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    And I press "Act as maintainer"
    When I fill in "Title" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Create Transaction"
    And I press "Cancel Transaction"
    Then I should see "Transaction was successfully cancelled"
    And I should see "Transaction was cancelled on"
    And I should not see "Cancel Transaction"

  @selenium
  Scenario: Cancel a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    And I press "Act as maintainer"
    And I fill in "Title" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Create Transaction"
    And I confirm a js popup on the next step
    And I press "Cancel Transaction"

    When the system processes jobs
    And I am on the "Bake bread for George" transaction page
  
    Then I should see "Transaction was stopped on"
    
  

  
