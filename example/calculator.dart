class Calculator {
  final List<num> _cachedNumbers = <num>[];
  final List<String> _cachedCharacters = <String>[];
  final List<num> _results = <num>[];

  void storeNumericInput(num input) => _cachedNumbers.add(input);
  void storeCharacterInput(String input) => _cachedCharacters.add(input);

  num _retrieveNumericInput() => _cachedNumbers.removeAt(0);

  num add() {
    final result = _retrieveNumericInput() + _retrieveNumericInput();
    _results.add(result);

    return result;
  }

  num countStringCharacters() {
    num result = 0;
    for (var i = 0; i < _cachedCharacters[0].length; i += 1) {
      result += _cachedCharacters[0].codeUnitAt(i);
    }

    _cachedCharacters.clear();
    _results.add(result);

    return result;
  }

  num evalulateExpression(String expression) => 1;

  num getNumericResult() => _results.removeLast();

  void dispose() {
    _cachedNumbers.clear();
    _results.clear();
  }
}
