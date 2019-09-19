# language: de
Funktionalität: Calculator
  Tests the addition of two numbers

  Szenariogrundriss: Add two numbers
    Gegeben sei the numbers <number_one> and <number_two>
    Wenn they are added
    Dann the expected result is <result>

    Beispiele:
      | number_one | number_two | result |
      | 12         | 5          | 17     |
      | 20         | 5          | 25     |
      | 20937      | 1          | 20938  |
      | 20.937     | -1.937     | 19     |
