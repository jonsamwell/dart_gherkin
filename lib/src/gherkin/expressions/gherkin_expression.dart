import '../parameters/custom_parameter.dart';
import '../parameters/step_defined_parameter.dart';

class _SortedParameterPosition {
  final int? startPosition;
  final CustomParameter<dynamic> parameter;

  _SortedParameterPosition(this.startPosition, this.parameter);
}

class GherkinExpression {
  final RegExp? originalExpression;
  final List<_SortedParameterPosition> _sortedParameterPositions =
      <_SortedParameterPosition>[];
  late RegExp _expression;

  GherkinExpression(this.originalExpression,
      Iterable<CustomParameter<dynamic>> customParameters) {
    var pattern = originalExpression!.pattern;
    customParameters.forEach((p) {
      if (originalExpression!.pattern.contains(p.identifier)) {
        // we need the index in the original pattern to be able to
        // transform the parameter into the correct type later on
        // so get that then modify the new matching pattern.
        originalExpression!.pattern.replaceAllMapped(
            RegExp(_escapeIdentifier(p.identifier),
                caseSensitive: true, multiLine: true), (m) {
          _sortedParameterPositions.add(_SortedParameterPosition(m.start, p));

          return m.input;
        });
        pattern = pattern.replaceAllMapped(
            RegExp(_escapeIdentifier(p.identifier),
                caseSensitive: true, multiLine: true),
            (m) => p.pattern.pattern);
      }
    });

    // check for any capture patterns that are not custom parameters
    // but defined directly in the step definition for example:
    //  Given I (open|close) the drawer(s)
    // note that we should ignore the predefined (s) plural parameter
    // and also ignore the (?:) non-capturing group pattern
    var inCustomBracketSection = false;
    int? indexOfOpeningBracket;
    for (var i = 0; i < originalExpression!.pattern.length; i += 1) {
      final char = originalExpression!.pattern[i];
      if (char == '(') {
        // look ahead and make sure we don't see "s)" or "?:" which would
        // indicate the plural parameter or a non-capturing group
        if (originalExpression!.pattern.length > i + 2) {
          final justAhead = originalExpression!.pattern[i + 1] +
              originalExpression!.pattern[i + 2];
          if (justAhead != 's)' && justAhead != '?:') {
            inCustomBracketSection = true;
            indexOfOpeningBracket = i;
          }
        }
      } else if (char == ')' && inCustomBracketSection) {
        _sortedParameterPositions.add(_SortedParameterPosition(
            indexOfOpeningBracket, UserDefinedStepParameterParameter()));
        inCustomBracketSection = false;
        indexOfOpeningBracket = 0;
      }
    }

    _sortedParameterPositions.sort((a, b) => a.startPosition! - b.startPosition!);
    _expression = RegExp(pattern,
        caseSensitive: originalExpression!.isCaseSensitive,
        multiLine: originalExpression!.isMultiLine);
  }

  String _escapeIdentifier(String identifier) =>
      identifier.replaceAll('(', '\\(').replaceAll(')', '\\)');

  bool isMatch(String input) {
    return _expression.hasMatch(input);
  }

  Iterable<dynamic> getParameters(String input) {
    final stringValues = <String?>[];
    final values = <dynamic>[];
    _expression.allMatches(input).forEach((m) {
      // the first group is always the input string
      final indices =
          List.generate(m.groupCount, (i) => i + 1, growable: false).toList();
      stringValues.addAll(m.groups(indices));
    });

    final definedParameters = _sortedParameterPositions
        .where((x) => x.parameter.includeInParameterList)
        .toList();

    for (var i = 0; i < stringValues.length; i += 1) {
      final val = stringValues.elementAt(i);
      final cp = definedParameters.elementAt(i);
      if (cp.parameter.includeInParameterList) {
        values.add(cp.parameter.transformer(val));
      }
    }

    return values;
  }
}
