@a
Feature: Calculator can work with strings
  Tests that the calculator can count the total value of the character code units in a string

  @debug
  Scenario Outline: Counts string's code units
    Given the characters "<characters>"
    When they are counted
    Then the expected result is <result>

    Examples:
      | characters | result |
      | abc        | 294    |
      | a b c      | 358    |
      | a \n b \c  | 684    |
