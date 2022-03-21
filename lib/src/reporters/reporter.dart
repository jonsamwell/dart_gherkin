import 'dart:async';

import 'package:collection/collection.dart';

import 'message_level.dart';
import 'messages.dart';

typedef VoidCallback = void Function();

typedef ReportInvoke<T extends Reporter> = Future<void>? Function(T report);

typedef FutureAction = Future<void> Function();

typedef ActionReport<T> = Future<void> Function([T? message]);

typedef FutureValueAction<T> = Future<void> Function(T message);

/// {@template reporter.reporteractionhandler}
/// Auxiliary class for setting the start and end functions
/// {@endtemplate}
class ReportActionHandler<S extends Object?, F extends Object?> {
  /// Provides interaction with the function after the start of a certain action
  ///
  final StateAction<S> onStarted;
  final StateAction<F> onFinished;

  /// {@macro reporter.reporteractionhandler}
  ReportActionHandler({
    ActionReport<S>? onStarted,
    ActionReport<F>? onFinished,
  })  : onStarted = StateAction<S>(action: onStarted),
        onFinished = StateAction<F>(action: onFinished);

  List<StateAction> get stateActions => [onStarted, onFinished];

  factory ReportActionHandler.empty() => ReportActionHandler<S, F>();
}

/// {@template reporter.stateaction}
/// Auxiliary class for performing various actions
/// {@endtemplate}
class StateAction<T extends Object?> {
  final ActionReport<T>? _action;

  /// {@macro reporter.stateaction}
  ///
  /// [action] - an action is a callback function
  StateAction({
    ActionReport<T>? action,
  }) : _action = action;

  /// The function of safely calling an action.
  /// Inside notifies listeners (calls [notifyListeners]).
  Future<void> maybeCall([T? value]) async {
    if (_action != null) {
      await _action!.call(value);
    }
  }
}

/// {@template reporter.reporter}
/// An abstract class both for all reporters
/// {@endtemplate}
abstract class Reporter {}

/// {@template reporter.testrepoter}
/// An abstract class that allows you to track the status of the start of tests.
/// {@endtemplate}
abstract class TestReporter implements Reporter {
  ReportActionHandler<void, void> get test;
}

/// {@template reporter.featurerepoter}
/// An abstract class that allows you to track the status of features.
/// {@endtemplate}
abstract class FeatureReporter implements Reporter {
  ReportActionHandler<StartedMessage, FinishedMessage> get feature;
}

/// {@template reporter.scenariorepoter}
/// An abstract class that allows you to track the status of scenarios.
/// {@endtemplate}
abstract class ScenarioReporter implements Reporter {
  ReportActionHandler<StartedMessage, ScenarioFinishedMessage> get scenario;
}

/// {@template reporter.steprepoter}
/// An abstract class that allows you to track the status of steps.
/// {@endtemplate}
abstract class StepReporter implements Reporter {
  ReportActionHandler<StepStartedMessage, StepFinishedMessage> get step;
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

/// {@template reporter.messagerepoter}
/// An abstract class that allows you to send messages and intercept them.
/// {@endtemplate}
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

/// {@template reporter.fullfeature}
/// This is an abstraction for the implementation
/// of all methods for generating reports without [TestReporter]
/// {@endtemplate}
abstract class FullFeatureReporter
    implements
        FeatureReporter,
        StepReporter,
        InfoReporter,
        ScenarioReporter,
        DisposableRepoter {}

/// {@template reporter.fullrepoter}
/// This interface is necessary for tracking errors and displaying
/// various messages in the reporter
/// {@endtemplate}
abstract class InfoReporter implements MessageReporter, ExceptionReporter {}

/// {@template reporter.allreporters}
/// This mixin allows you to create aggregating reporters.
/// {@endtemplate}
mixin AllReporters implements Reporter {
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
