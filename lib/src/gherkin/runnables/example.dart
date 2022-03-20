import 'package:gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:gherkin/src/gherkin/models/table.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

class ExampleRunnable extends TaggableRunnableBlock {
  final String _name;
  GherkinTable? table;
  String? description;

  ExampleRunnable(
    this._name,
    RunnableDebugInformation debug,
  ) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TableRunnable:
        if (table != null) {
          throw GherkinSyntaxException(
            "Only a single table can be added to the example '$name'",
          );
        }

        table = (child as TableRunnable).toTable();
        break;
      case TagsRunnable:
        addTag(child as TagsRunnable);
        break;
      default:
        throw Exception(
          "Unknown runnable child given to Step '${child.runtimeType}'",
        );
    }
  }
}
