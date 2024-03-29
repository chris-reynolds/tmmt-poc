// file: Test Utils
// author: Chris Reynolds
// date: 21st October 2021
import 'dart:io';
import 'dart:math' as math;
import 'package:test/test.dart';

//TASK: Create a file comparison utility function,M,F,2021-10-06,2021-10-19,2021-10-23

var TEST_DIR = 'test/testdata';

testTodo(String name) {
  test(name, () {}, skip: 'TODO $name');
}

class TestUtils_file {
  static String directory = 'test/scratch';
  static bool check({
    required String sourceFilename,
  }) {
    throw 'TestUtils_file.compare todo ';
  }

  static String compare({required String sourceFilename, required String targetFilename}) {
    var sourceFile = File(sourceFilename);
    var targetFile = File(targetFilename);
    if (!sourceFile.existsSync() && !targetFile.existsSync())
      return 'Neither file exists : ${sourceFilename} nor ${targetFilename}';
    else if (!sourceFile.existsSync())
      return 'Source file does not exist : ${sourceFilename}';
    else if (!targetFile.existsSync())
      return 'Target file does not exist : ${targetFilename}';
    else {
      // both file exist so lets load and compare
      var sourceLines = sourceFile.readAsLinesSync();
      var targetLines = targetFile.readAsLinesSync();
      var lineCount = math.min(sourceLines.length, targetLines.length);
      for (var i = 0; i < lineCount; i++) {
        if (sourceLines[i] != targetLines[i])
          return 'Line ${i + 1} : Found "${sourceLines[i]}" but expected "${targetLines[i]}"';
      }
      if (math.max(sourceLines.length, targetLines.length) != lineCount)
        return 'Line count is different. ${sourceFilename} has ${sourceLines.length} but $targetFilename has ${targetLines.length}';
      else
        return ''; // perfect match
    }
  } // of compare

  static bool exists(String filename) => File(fullFilename(filename)).existsSync();
  static int length(String filename) => File(fullFilename(filename)).lengthSync();
  static DateTime lastModified(String filename) => File(fullFilename(filename)).lastModifiedSync();
  static String contents(String filename) => File(fullFilename(filename)).readAsStringSync();
  static fullFilename(String filename) =>
      filename.contains('/') ? filename : '$directory/$filename';
  static cleanDirectory() {
    Directory(directory).createSync(recursive: true);
    var scratchDirectory = Directory(directory);
    for (var scratchFile in scratchDirectory.listSync()) scratchFile.deleteSync();
  }
} // of TestUtils_file
