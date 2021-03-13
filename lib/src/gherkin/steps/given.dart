import './step_configuration.dart';
import './step_definition.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class GivenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  GivenWithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given extends GivenWithWorld<World> {
  Given([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Given1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Given1WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given1<TInput1> extends Given1WithWorld<TInput1, World> {
  Given1([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Given2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Given2WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given2<TInput1, TInput2>
    extends Given2WithWorld<TInput1, TInput2, World> {
  Given2([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Given3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Given3WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given3<TInput1, TInput2, TInput3>
    extends Given3WithWorld<TInput1, TInput2, TInput3, World> {
  Given3([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Given4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Given4WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given4<TInput1, TInput2, TInput3, TInput4>
    extends Given4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Given4([StepDefinitionConfiguration? configuration]) : super(configuration);
}

abstract class Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Given5WithWorld([StepDefinitionConfiguration? configuration])
      : super(configuration);
}

abstract class Given5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        World> {
  Given5([StepDefinitionConfiguration? configuration]) : super(configuration);
}

StepDefinitionGeneric<TWorld> given<TWorld extends World>(
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

StepDefinitionGeneric<TWorld> given1<TInput1, TWorld extends World>(
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

StepDefinitionGeneric<TWorld> given2<TInput1, TInput2, TWorld extends World>(
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
    given3<TInput1, TInput2, TInput3, TWorld extends World>(
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
    given4<TInput1, TInput2, TInput3, TInput4, TWorld extends World>(
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
    given5<TInput1, TInput2, TInput3, TInput4, TInput5, TWorld extends World>(
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
