import 'dart:io';
import 'package:test/test.dart';
import 'testUtils.dart';
import '../bin/fileSink.dart' as Sink;

main() {
  setUp(() {
    Sink.CONFIG_FILE = 'test/test_fileSink.config.yaml';
    TestUtils_file.directory = 'test/scratch';
    TestUtils_file.cleanDirectory();
  }); // of setUp

  tearDown(() {}); // of tearDown
  group('FileSync', () {
    test('Ensure one file is written', () {
      String text = makeOutputString('fred', 'blah');
      assert(!TestUtils_file.exists('fred'), 'check output file does not exists');
      Sink.main(text.split('\n'));
      assert(TestUtils_file.exists('fred'), 'check output file exists');
      assert(TestUtils_file.length('fred') == 5, 'check output file length');
    });
    test('Ensure two files are written', () {
      String text = makeOutputString('fred1', 'blahblah\n') + makeOutputString('fred2', 'blah');
      Sink.main(text.split('\n'));
      assert(TestUtils_file.exists('fred1'), 'check output file exists');
      assert(TestUtils_file.length('fred1') == 9, 'check output file length');
      assert(TestUtils_file.exists('fred2'), 'check output file exists');
      assert(TestUtils_file.length('fred2') == 5, 'check output file length');
    });
    test('Only write to existing file if contents have changed', () {
      String text = makeOutputString('fred3', 'blahblah\n');
      Sink.main(text.split('\n'));
      var lastModified1 = TestUtils_file.lastModified('fred3');
      Sink.main(text.split('\n')); // try generating again
      sleep(Duration(seconds: 2));
      var lastModified2 = TestUtils_file.lastModified('fred3');
      assert(lastModified1 == lastModified2, 'File should be unchanged on second write');
      text = makeOutputString('fred3', 'not blahblah\n'); // changed
      Sink.main(text.split('\n')); // try generating again
      sleep(Duration(seconds: 2));
      var lastModified3 = TestUtils_file.lastModified('fred3');
      assert(lastModified1 != lastModified3, 'File should be changed on third write');
    });
    test('Protect custom code blocks', () {
      String neutralText =
          makeOutputString('fred5', 'blahblah\n') + customCodeMarker('manual') + 'tail\n';
      String manualText = makeOutputString('fred5', 'blahblah\n') +
          customCodeSection('manual', 'gibberish') +
          'tail\n';
      Sink.main(manualText.split('\n')); // first initialised the file with some gibberish content
      sleep(Duration(seconds: 1));
      Sink.main(neutralText.split('\n')); // overwrite with no gibberish
      assert(TestUtils_file.contents('fred5').contains('gibberish'),
          'Custom code contents should survive');
    });
    testTodo('Insert codegen blocks');
    testTodo('Allow custom code blocks to be initialised');
    testTodo('Backup original file if required');
  });
} // of main

String makeOutputString(String filename, String contents) =>
    '%output ${TestUtils_file.directory}/$filename\n$contents';
String customCodeMarker(String name) => '%customcode $name\n';
String customCodeSection(String name, String contents) =>
    '''//                                  '*** Start customcode $name
$contents 
//                                  '*** End customcode $name 
''';
