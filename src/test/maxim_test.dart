// file: maxim_test
// author: Chris Reynolds
// date: 26th of October 2021
import 'package:test/test.dart';
//import 'dart:io';
import 'testUtils.dart';
import '../lib/mmodel.dart';
import '../lib/writer.dart';
//import '../lib/target_platform.dart';
import '../bin/fileSink.dart' as Sink;

/// Purpose of this file
/// This is to compare the output of the Maxim generator
/// with the output of the tmmt generator
/// *
///
main() {
  setUp(() {
    Sink.testMode = true;
    Sink.CONFIG_FILE = 'test/test_fileSink.config.yaml';
    TestUtils_file.directory = 'test/testdata';
  }); // of setUp
//TASK: Mimic security database ddl,L,I,2021-10-26,2021-10-06
  test('IntegratedTest.Mimic security database ddl', () {
    var secModel = MModel('$TEST_DIR/jobuniverse.json', systemName: 'Security');
    //var platform = TargetPlatform('mysql_ddl.cds');
    var writer =
        Writer('$TEST_DIR/mysql_ddl.mustache', model: secModel, platform: 'TODO: sort platform');
    var output = writer.render();
    Sink.main(output.split('\n'));
    var matchResult = TestUtils_file.compare(
        sourceFilename: '$TEST_DIR/sec10_tables_poc.sql',
        targetFilename: '$TEST_DIR/sec10_tables_maxim.sql');
    assert(matchResult == '', matchResult);
  });
//TASK: Mimic jobuniverse ddl,M,W,2021-10-16
  testTodo('IntegratedTest.Mimic jobuniverse ddl');
//TASK: Mimic security model,M,W,2021-10-16
  testTodo('IntegratedTest.Mimic security model');
//TASK: Mimic security controller,M,W,2021-10-16
  testTodo('IntegratedTest.Mimic security controller');
//TASK: Mimic security view form,M,W,2021-10-16
  testTodo('IntegratedTest.Mimic security view form');
}
