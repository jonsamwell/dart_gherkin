Feature: Calculator
  Tests the addition of two numbers

  Scenario Outline: Add two numbers
    Given the numbers <number_one> and <number_two>
    When they are added
    Then the expected result is <result>

    Examples:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |
