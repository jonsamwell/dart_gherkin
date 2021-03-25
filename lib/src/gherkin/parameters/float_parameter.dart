import './custom_parameter.dart';

class FloatParameterBase extends CustomParameter<num> {
  FloatParameterBase(String name)
      : super(name, RegExp(r'(-?[0-9]+\.?[0-9]*)'), (String? input) {
          final n = input != null ? num.parse(input) : 0;
          return n;
        });
}

class FloatParameterLower extends FloatParameterBase {
  FloatParameterLower() : super('float');
}

class FloatParameterCamel extends FloatParameterBase {
  FloatParameterCamel() : super('Float');
}

class NumParameterLower extends FloatParameterBase {
  NumParameterLower() : super('num');
}

class NumParameterCamel extends FloatParameterBase {
  NumParameterCamel() : super('Num');
}
