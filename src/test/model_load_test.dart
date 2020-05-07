import '../bin/mmodel.dart';
import '../bin/writer.dart';
import '../bin/target_platform.dart';
import 'package:test/test.dart';

void main() async {
  test('Load Job universe model and make sure it has 42 classes', (){
    var juModel = (MModel('jobuniverse.json'));
    var classes = juModel['classes'];
    assert(classes.length==42);
  });
  test('Mustache is working',(){
    var juModel = (MModel('jobuniverse.json'));
    var writer = Writer('test.mustache',model:juModel);
  	var output = writer.render();
    print(output);
    assert(output.split('\n').length ==45);
  });
  test('Platform CSS Parser is working',(){
    var fred = TargetPlatform('test_platform.cds');
    assert(fred != null && fred.runtimeType.toString() == 'TargetPlatform');
    var juModel = (MModel('jobuniverse.json'));
    juModel.platform = fred;
    
  });
} // of main
