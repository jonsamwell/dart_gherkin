import 'package:gherkin/gherkin.dart';
import 'dart:math';

class PowerOfTwoParameter extends CustomParameter<int> {
  PowerOfTwoParameter()
      : super(
          'POW',
          RegExp(r'([0-9]+\^[0-9]+)', caseSensitive: true),
          (input) {
            final parts = input.split('^');
            return pow(int.parse(parts[0]), int.parse(parts[1])) as int;
          },
        );
}
