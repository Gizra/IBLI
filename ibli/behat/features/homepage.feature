Feature: Test tasks
  Test the homepage

  @api
  Scenario: Verify menu items are displayed.
    Given I visit "/"
     Then I should see "IBLI"
      And I should see "Pages"
      And I should see "Partners"
      And I should see "Blog"
      And I should see "Contact Us"
