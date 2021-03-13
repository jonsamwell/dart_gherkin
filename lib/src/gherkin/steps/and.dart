import './step_configuration.dart';
import './step_definition.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class And extends StepDefinition<World> {
  And([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class AndWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  AndWithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  And1WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And1<TInput1> extends And1WithWorld<TInput1, World> {
  And1([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class And2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  And2WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And2<TInput1, TInput2>
    extends And2WithWorld<TInput1, TInput2, World> {
  And2([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class And3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  And3WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And3<TInput1, TInput2, TInput3>
    extends And3WithWorld<TInput1, TInput2, TInput3, World> {
  And3([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class And4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  And4WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And4<TInput1, TInput2, TInput3, TInput4>
    extends And4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  And4([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class And5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  And5WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class And5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends And5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  And5([StepDefinitionConfiguration? configuration]) : super(configuration);
}

StepDefinitionGeneric<TWorld> and<TWorld extends World>(
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

StepDefinitionGeneric<TWorld> and1<TInput1, TWorld extends World>(
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

StepDefinitionGeneric<TWorld> and2<TInput1, TInput2, TWorld extends World>(
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
    and3<TInput1, TInput2, TInput3, TWorld extends World>(
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
    and4<TInput1, TInput2, TInput3, TInput4, TWorld extends World>(
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
    and5<TInput1, TInput2, TInput3, TInput4, TInput5, TWorld extends World>(
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
