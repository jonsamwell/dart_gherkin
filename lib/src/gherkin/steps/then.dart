import './step_configuration.dart';
import './step_definition.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class Then extends StepDefinition<World> {
  Then([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class ThenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  ThenWithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Then1WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then1<TInput1> extends Then1WithWorld<TInput1, World> {
  Then1([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Then2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Then2WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then2<TInput1, TInput2>
    extends Then2WithWorld<TInput1, TInput2, World> {
  Then2([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Then3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Then3WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then3<TInput1, TInput2, TInput3>
    extends Then3WithWorld<TInput1, TInput2, TInput3, World> {
  Then3([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Then4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Then4WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then4<TInput1, TInput2, TInput3, TInput4>
    extends Then4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Then4([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Then5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Then5WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Then5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Then5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  Then5([StepDefinitionConfiguration? configuration]) : super(configuration);
}

StepDefinitionGeneric<TWorld> then<TWorld extends World>(
  Pattern pattern,
  Future<void> Function(StepContext<TWorld> context) onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
    step<TWorld, dynamic, dynamic, dynamic, dynamic, dynamic>(
      pattern,
      0,
      onInvoke,
      configuration: configuration,
    );

StepDefinitionGeneric<TWorld> then1<TInput1, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
    step<TWorld, TInput1, dynamic, dynamic, dynamic, dynamic>(
      pattern,
      1,
      onInvoke,
      configuration: configuration,
    );

StepDefinitionGeneric<TWorld> then2<TInput1, TInput2, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
    step<TWorld, TInput1, TInput2, dynamic, dynamic, dynamic>(
      pattern,
      2,
      onInvoke,
      configuration: configuration,
    );

StepDefinitionGeneric<TWorld>
    then3<TInput1, TInput2, TInput3, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, dynamic, dynamic>(
          pattern,
          3,
          onInvoke,
          configuration: configuration,
        );

StepDefinitionGeneric<TWorld>
    then4<TInput1, TInput2, TInput3, TInput4, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, TInput4, dynamic>(
          pattern,
          4,
          onInvoke,
          configuration: configuration,
        );

StepDefinitionGeneric<TWorld>
    then5<TInput1, TInput2, TInput3, TInput4, TInput5, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput1 input2,
    TInput1 input3,
    TInput1 input4,
    TInput1 input5,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration? configuration,
}) =>
        step<TWorld, TInput1, TInput2, TInput3, TInput4, TInput5>(
          pattern,
          5,
          onInvoke,
          configuration: configuration,
        );
