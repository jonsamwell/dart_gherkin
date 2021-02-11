import 'package:gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group('addChild', () {
    test('can add CommentLineRunnable', () {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(CommentLineRunnable('', debugInfo));
    });
    test('can add TableRunnable', () {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| Header 1 | Header 2 |'));
      runnable.addChild(TableRunnable(debugInfo)..rows.add('|  1 | 2 |'));
      runnable.addChild(TableRunnable(debugInfo)..rows.add('|  3 | 4 |'));
      expect(runnable.rows.length, 3);
      expect(runnable.rows,
          ['| Header 1 | Header 2 |', '|  1 | 2 |', '|  3 | 4 |']);
    });
  });

  group('to table', () {
    test('single row table has no header row', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      final table = runnable.toTable();
      expect(table.header, isNull);
      expect(table.rows.length, 1);
      expect(table.rows.first.columns, ['one', 'two', 'three']);
    });

    test('single row table as map', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 1);
      expect(maps.elementAt(0), {'0': 'one', '1': 'two', '2': 'three'});
    });

    test('two row table has header row', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ['header one', 'header two', 'header three']);
      expect(table.rows.length, 1);
      expect(table.rows.elementAt(0).columns, ['one', 'two', 'three']);
    });

    test('two row table as map', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 1);
      expect(maps.elementAt(0),
          {'header one': 'one', 'header two': 'two', 'header three': 'three'});
    });

    test('three row table has header row and correct rows', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| four | five | six |'));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ['header one', 'header two', 'header three']);
      expect(table.rows.length, 2);
      expect(table.rows.elementAt(0).columns, ['one', 'two', 'three']);
      expect(table.rows.elementAt(1).columns, ['four', 'five', 'six']);
    });

    test('three row table as map', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| one | two | three |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| four | five | six |'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 2);
      expect(maps.elementAt(0),
          {'header one': 'one', 'header two': 'two', 'header three': 'three'});
      expect(maps.elementAt(1),
          {'header one': 'four', 'header two': 'five', 'header three': 'six'});
    });

    test('table removes columns leading and trailing spaces', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('|   one |    two    |       three          |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('|four    |     five    |six|'));
      final table = runnable.toTable();
      expect(table.header, isNotNull);
      expect(
          table.header.columns, ['header one', 'header two', 'header three']);
      expect(table.rows.length, 2);
      expect(table.rows.elementAt(0).columns, ['one', 'two', 'three']);
      expect(table.rows.elementAt(1).columns, ['four', 'five', 'six']);
    });

    test(
        'table removes columns leading and trailing spaces when converted to map',
        () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('|   one |    two    |       three          |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('|four    |     five    |six|'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 2);
      expect(maps.elementAt(0),
          {'header one': 'one', 'header two': 'two', 'header three': 'three'});
      expect(maps.elementAt(1),
          {'header one': 'four', 'header two': 'five', 'header three': 'six'});
    });

    test('table allows empty columns when converted to map', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| header one | header two | header three |'));
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add('| one | two |                 |'));
      runnable.addChild(TableRunnable(debugInfo)..rows.add('| | five | six |'));
      runnable.addChild(
          TableRunnable(debugInfo)..rows.add('| seven | eight | nine |'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 3);
      expect(maps.elementAt(0), {
        'header one': 'one',
        'header two': 'two',
        'header three': null,
      });
      expect(maps.elementAt(1), {
        'header one': null,
        'header two': 'five',
        'header three': 'six',
      });
      expect(maps.elementAt(2), {
        'header one': 'seven',
        'header two': 'eight',
        'header three': 'nine',
      });
    });

    test('pipes can be escaped', () async {
      final runnable = TableRunnable(debugInfo);
      runnable.addChild(TableRunnable(debugInfo)
        ..rows.add(
            r'| one \| with escaped pipe | two | three with \| escaped pipe |'));
      final maps = runnable.toTable().asMap();
      expect(maps.length, 1);
      expect(maps.elementAt(0), {
        '0': 'one | with escaped pipe',
        '1': 'two',
        '2': 'three with | escaped pipe'
      });
    });
  });
}
