import './step_configuration.dart';
import './step_definition.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class Step extends StepDefinition<World> {
  Step([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class StepWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  StepWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Step1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step1<TInput1> extends Step1WithWorld<TInput1, World> {
  Step1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Step2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Step2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step2<TInput1, TInput2>
    extends Step2WithWorld<TInput1, TInput2, World> {
  Step2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Step3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Step3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step3<TInput1, TInput2, TInput3>
    extends Step3WithWorld<TInput1, TInput2, TInput3, World> {
  Step3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Step4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Step4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step4<TInput1, TInput2, TInput3, TInput4>
    extends Step4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Step4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Step5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Step5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Step5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Step5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  Step5([StepDefinitionConfiguration configuration]) : super(configuration);
}

StepDefinitionGeneric<TWorld> step<TWorld extends World>(
  Pattern pattern,
  Future<void> Function(StepContext<TWorld> context) onInvoke, {
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, dynamic, dynamic, dynamic, dynamic, dynamic>(
    pattern,
    0,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld> step1<TInput1, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, TInput1, dynamic, dynamic, dynamic, dynamic>(
    pattern,
    1,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld> step2<TInput1, TInput2, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, TInput1, TInput2, dynamic, dynamic, dynamic>(
    pattern,
    2,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld>
    step3<TInput1, TInput2, TInput3, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, TInput1, TInput2, TInput3, dynamic, dynamic>(
    pattern,
    3,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld>
    step4<TInput1, TInput2, TInput3, TInput4, TWorld extends World>(
  Pattern pattern,
  Future<void> Function(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
    StepContext<TWorld> context,
  )
      onInvoke, {
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, TInput1, TInput2, TInput3, TInput4, dynamic>(
    pattern,
    4,
    onInvoke,
    configuration: configuration,
  );
}

StepDefinitionGeneric<TWorld>
    step5<TInput1, TInput2, TInput3, TInput4, TInput5, TWorld extends World>(
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
  StepDefinitionConfiguration configuration,
}) {
  return stepWith<TWorld, TInput1, TInput2, TInput3, TInput4, TInput5>(
    pattern,
    5,
    onInvoke,
    configuration: configuration,
  );
}
