import './step_configuration.dart';
import './step_definition_implementations.dart';
import './world.dart';

abstract class But extends StepDefinition<World> {
  But([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class ButWithWorld<TWorld extends World>
    extends StepDefinition<TWorld> {
  ButWithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But1WithWorld<TInput1, TWorld extends World>
    extends StepDefinition1<TWorld, TInput1> {
  But1WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But1<TInput1> extends But1WithWorld<TInput1, World> {
  But1([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class But2WithWorld<TInput1, TInput2, TWorld extends World>
    extends StepDefinition2<TWorld, TInput1, TInput2> {
  But2WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But2<TInput1, TInput2>
    extends But2WithWorld<TInput1, TInput2, World> {
  But2([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class But3WithWorld<TInput1, TInput2, TInput3, TWorld extends World>
    extends StepDefinition3<TWorld, TInput1, TInput2, TInput3> {
  But3WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But3<TInput1, TInput2, TInput3>
    extends But3WithWorld<TInput1, TInput2, TInput3, World> {
  But3([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class But4WithWorld<TInput1, TInput2, TInput3, TInput4,
        TWorld extends World>
    extends StepDefinition4<TWorld, TInput1, TInput2, TInput3, TInput4> {
  But4WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But4<TInput1, TInput2, TInput3, TInput4>
    extends But4WithWorld<TInput1, TInput2, TInput3, TInput4, World> {
  But4([StepDefinitionConfiguration configuration]) : super(configuration);
}

abstract class But5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5,
        TWorld extends World>
    extends StepDefinition5<TWorld, TInput1, TInput2, TInput3, TInput4,
        TInput5> {
  But5WithWorld([StepDefinitionConfiguration configuration])
      : super(configuration);
}

abstract class But5<TInput1, TInput2, TInput3, TInput4, TInput5>
    extends But5WithWorld<TInput1, TInput2, TInput3, TInput4, TInput5, World> {
  But5([StepDefinitionConfiguration configuration]) : super(configuration);
}
