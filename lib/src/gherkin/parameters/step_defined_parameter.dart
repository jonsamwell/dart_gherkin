import 'package:gherkin/src/gherkin/parameters/custom_parameter.dart';

class UserDefinedStepParameterParameter extends CustomParameter<String> {
  UserDefinedStepParameterParameter()
      : super(
          '',
          RegExp(''),
          (String input) => input,
        );
}
