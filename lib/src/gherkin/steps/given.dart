import './step_configuration.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class GivenWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  GivenWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given extends GivenWithWorld<World> {
  Given([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  Given1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given1<TInput1> extends Given1WithWorld<TInput1, World> {
  Given1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  Given2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given2<TInput1, TInput2>
    extends Given2WithWorld<TInput1, TInput2, World> {
  Given2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  Given3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given3<TInput1, TInput2, TInput3>
    extends Given3WithWorld<TInput1, TInput2, TInput3, World> {
  Given3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  Given4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given4<TInput1, TInput2, TInput3, TInput4>
    extends Given4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  Given4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  Given5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class Given5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends Given5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        World> {
  Given5([StepDefinitionConfiguration configuration]) : super(configuration);
}
