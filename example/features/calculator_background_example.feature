# comment ...

Feature: Calculator with Background
  Tests the addition feature of the calculator

  Background: Set the starting number
    Given the numbers 100 and 50
    And they are added

  @debug
  Scenario: Add two numbers with background
    A scenario description!
    Then the expected result is 150
