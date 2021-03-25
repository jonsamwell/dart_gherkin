import './custom_parameter.dart';

class PluralParameter extends CustomParameter<String?> {
  PluralParameter()
      : super(
          's',
          RegExp('(?:s)?'),
          (String? input) => null,
          identifierPrefix: '(',
          identifierSuffix: ')',
          includeInParameterList: false,
        );
}
