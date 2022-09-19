import '../lib/mmodel.dart';
import '../lib/writer.dart';
import '../lib/target_platform.dart';
import 'package:test/test.dart';
import 'testUtils.dart';

void main() async {
  test('Load Job universe model and make sure it has 42 classes', () {
    var juModel = (MModel('$TEST_DIR/jobuniverse.json'));
    var classes = juModel['classes'];
    assert(classes.length == 42);
  });
  test('Load Security model and make sure it has 7 classes', () {
    var secModel =
        (MModel('$TEST_DIR/jobuniverse.json', systemName: 'Security'));
    var classes = secModel['classes'];
    assert(classes.length == 7);
  });
  test('Mustache is working', () {
    var juModel = (MModel('$TEST_DIR/jobuniverse.json'));
    var writer = Writer('$TEST_DIR/test.mustache', model: juModel);
    var output = writer.render();
    print(output);
    assert(output.split('\n').length == 45);
  });
  test('Platform CSS Parser is working', () {
    var fred = TargetPlatform('$TEST_DIR/test_platform.cds');
    assert(fred.runtimeType.toString() == 'TargetPlatform');
    var juModel = (MModel('$TEST_DIR/jobuniverse.json'));
    juModel.platform = fred;
  });
} // of main
