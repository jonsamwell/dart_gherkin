import 'dart:mirrors';

import 'package:gherkin/src/gherkin/steps/step_definition.dart';

class StepDefinitionInstanceCreator {
  Future<StepDefinitionGeneric> createInstance(ClassMirror klass) {
    // get constructors
    final ctors = klass.declarations.values.where((d) =>
        d is MethodMirror &&
        d.isConstructor &&
        !d.isPrivate &&
        d.parameters.isEmpty);

    if (ctors.length > 1) {
      throw new Exception(
          '''Unable to create instance of step class `${klass.simpleName}` only step classes with a single, parameterless constructor can be automatically created.
          To create a instance of step definition classes with complex constructs consider implementing your own `StepDefinitionInstanceCreator` class and assigning it to your config.''');
    }

    final instance = klass.newInstance(Symbol.empty, []);

    return Future.value(instance.reflectee as StepDefinitionGeneric);
  }
}
