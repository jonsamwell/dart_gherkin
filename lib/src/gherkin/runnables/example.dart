import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';

import '../exceptions/syntax_error.dart';
import '../models/table.dart';
import './debug_information.dart';
import './runnable.dart';
import './table.dart';

class ExampleRunnable extends TaggableRunnableBlock {
  String _name;
  String description;
  Table table;

  ExampleRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TableRunnable:
        if (table != null) {
          throw GherkinSyntaxException(
              "Only a single table can be added to the example '$name'");
        }

        table = (child as TableRunnable).toTable();
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Step '${child.runtimeType}'");
    }
  }
}
