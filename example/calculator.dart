class Calculator {
  final List<num> _cachedNumbers = List<num>();
  final List<num> _results = List<num>();

  void storeNumericInput(num input) => _cachedNumbers.add(input);

  num _retrieveNumericInput() => _cachedNumbers.removeAt(0);

  num add() {
    final result = _retrieveNumericInput() + _retrieveNumericInput();
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
