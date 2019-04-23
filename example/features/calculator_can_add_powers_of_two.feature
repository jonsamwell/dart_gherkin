Feature: Calculator
  Tests the addition of powers of two feature of the calculator

  Scenario: Add two number which are powers of two
    Given the powers 2^10 and 5^9
    When they are added
    Then the expected result is 1954149
