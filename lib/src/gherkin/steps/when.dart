import './step_configuration.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class When extends StepDefinition<World> {
  When([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class WhenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  WhenWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  When1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When1<TInput1> extends When1WithWorld<TInput1, World> {
  When1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class When2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  When2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When2<TInput1, TInput2>
    extends When2WithWorld<TInput1, TInput2, World> {
  When2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class When3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  When3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When3<TInput1, TInput2, TInput3>
    extends When3WithWorld<TInput1, TInput2, TInput3, World> {
  When3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class When4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  When4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When4<TInput1, TInput2, TInput3, TInput4>
    extends When4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  When4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class When5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  When5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class When5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends When5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  When5([StepDefinitionConfiguration configuration]) : super(configuration);
}
