import '../lib/mmodel.dart';
import '../lib/writer.dart';
import '../lib/target_platform.dart';
import 'package:test/test.dart';

void main() async {
  test('Load Job universe model and make sure it has 42 classes', () {
    var juModel = (MModel('test/testdata/jobuniverse.json'));
    var classes = juModel['classes'];
    assert(classes.length == 42);
  });
  test('Mustache is working', () {
    var juModel = (MModel('test/testdata/jobuniverse.json'));
    var writer = Writer('test/testdata/test.mustache', model: juModel);
    var output = writer.render();
    print(output);
    assert(output.split('\n').length == 45);
  });
  test('Platform CSS Parser is working', () {
    var fred = TargetPlatform('test/testdata/test_platform.cds');
    assert(fred.runtimeType.toString() == 'TargetPlatform');
    var juModel = (MModel('test/testdata/jobuniverse.json'));
    juModel.platform = fred;
  });
} // of main
