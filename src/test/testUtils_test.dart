import 'testUtils.dart';
import 'package:test/test.dart';

main() {
  group('FileCompare', () {
    test('Identical files should match', () {
      var result = TestUtils_file.compare(
          sourceFilename: 'test/testdata/jobuniverse.json',
          targetFilename: 'test/testdata/jobuniverse.json');
      assert(result == '', 'Identical files match');
    });
    test('Different files should fail', () {
      var result = TestUtils_file.compare(
          targetFilename: 'test/testdata/jobuniverse.json',
          sourceFilename: 'test/testdata/jobuniverse_filediff_line10.json');
      assert(result.contains('Line 10'), result);
    });
    test('Target same with tail sould fail', () {
      var result = TestUtils_file.compare(
          sourceFilename: 'test/testdata/filecompare_shorter.txt',
          targetFilename: 'test/testdata/filecompare_longer.txt');
      assert(result.startsWith('Line count is different'), 'target should be longer');
    });
    test('Source same with tail sould fail', () {
      var result = TestUtils_file.compare(
          sourceFilename: 'test/testdata/filecompare_longer.txt',
          targetFilename: 'test/testdata/filecompare_shorter.txt');
      assert(result.startsWith('Line count is different'), 'source should be longer');
    });
    test('Non-existant source should fail', () {
      var result = TestUtils_file.compare(
          sourceFilename: 'test/testdata/filecompare_longer.txt', targetFilename: 'xxxx');
      assert(result.startsWith('Target file does not exist'), 'targetfilename is rubbish');
    });
    test('Non-existant target should fail', () {
      var result = TestUtils_file.compare(
          sourceFilename: 'xxxx', targetFilename: 'test/testdata/filecompare_longer.txt');
      assert(result.startsWith('Source file does not exist'), 'sourcefilename is rubbish');
    });
    test('Non-existant source and target should fail', () {
      var result = TestUtils_file.compare(sourceFilename: 'xxxx', targetFilename: 'yyyy');
      assert(result.startsWith('Neither file exist'), 'both filenames are rubbish');
    });
  });
}
