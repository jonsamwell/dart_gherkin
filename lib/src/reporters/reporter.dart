import 'package:collection/collection.dart';

import 'package:gherkin/src/reporters/message_level.dart';
import 'package:gherkin/src/reporters/messages.dart';

typedef StartedCallback = Future<void> Function(StartedMessage message);
typedef FinishedCallback = Future<void> Function(FinishedMessage message);
typedef ScenarioFinishedCallback = Future<void> Function(
  ScenarioFinishedMessage message,
);
typedef StepStartedCallback = Future<void> Function(StepStartedMessage message);
typedef StepFinishedCallback = Future<void> Function(
  StepFinishedMessage message,
);

typedef ReportInvoke<T extends Reporter> = Future<void>? Function(T r);

typedef FutureCallback = Future<void> Function();

/// {@template reporter.repotermap}
/// Auxiliary class for setting the start and end functions
/// {@endtemplate}
class ReporterMap<S extends Function, F extends Function> {
  final S? onStarted;
  final F? onFinished;

  const ReporterMap({
    this.onStarted,
    this.onFinished,
  });

  static ReporterMap get empty => const ReporterMap();
}

abstract class Reporter {}

/// {@template reporter.testrepoter}
/// An abstract class that allows you to track the status of the start of tests.
/// {@endtemplate}
abstract class TestReporter implements Reporter {
  ReporterMap<FutureCallback, FutureCallback> get onTest;
}

/// {@template reporter.featurerepoter}
/// An abstract class that allows you to track the status of features.
/// {@endtemplate}
abstract class FeatureReporter implements Reporter {
  ReporterMap<StartedCallback, FinishedCallback> get onFeature;
}

/// {@template reporter.scenariorepoter}
/// An abstract class that allows you to track the status of scenarios.
/// {@endtemplate}
abstract class ScenarioReporter implements Reporter {
  ReporterMap<StartedCallback, ScenarioFinishedCallback> get onScenario;
}

/// {@template reporter.steprepoter}
/// An abstract class that allows you to track the status of steps.
/// {@endtemplate}
abstract class StepReporter implements Reporter {
  ReporterMap<StepStartedCallback, StepFinishedCallback> get onStep;
}

/// {@template reporter.exceptionrepoter}
/// An abstract class that allows you to track the status of exceptions.
/// {@endtemplate}
abstract class ExceptionReporter implements Reporter {
  Future<void> onException(Object exception, StackTrace stackTrace);
}

/// {@template reporter.messagerepoter}
/// An abstract class that allows you to send messages and intercept them.
/// {@endtemplate}
abstract class MessageReporter implements Reporter {
  Future<void> message(String message, MessageLevel level);
}

abstract class DisposableRepoter implements Reporter {
  Future<void> dispose();
}

/// {@template reporter.fullrepoter}
/// This is an abstraction for the implementation
/// of all methods for generating reports
/// {@endtemplate}
abstract class FullReporter
    implements
        TestReporter,
        FeatureReporter,
        StepReporter,
        InfoReporter,
        ScenarioReporter,
        DisposableRepoter {}

abstract class FullFeatureReporter
    implements
        FeatureReporter,
        StepReporter,
        InfoReporter,
        ScenarioReporter,
        DisposableRepoter {}

abstract class InfoReporter implements MessageReporter, ExceptionReporter {}

/// {@template reporter.manyrepoters}
/// This abstraction allows you to create aggregating reporters.
/// {@endtemplate}
mixin ManyRepoters implements Reporter {
  /// Get repoters
  UnmodifiableListView<Reporter> get repoters;

  /// A function that allows you to combine a certain function
  /// for all [reporters] and call it as one
  Future<void> invokeReporters<T extends Reporter>(ReportInvoke<T> invoke) {
    final validReportCallbacks =
        repoters.whereType<T>().map(invoke).whereNotNull();

    return Future.wait(validReportCallbacks);
  }
}
