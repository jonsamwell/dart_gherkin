import './custom_parameter.dart';

class StringParameterBase extends CustomParameter<String> {
  StringParameterBase(String name)
      : super(name, RegExp("['\"](.*)['\"]", dotAll: true), (String? input) => input ?? '');
}

class StringParameterLower extends StringParameterBase {
  StringParameterLower() : super('string');
}

class StringParameterCamel extends StringParameterBase {
  StringParameterCamel() : super('String');
}
