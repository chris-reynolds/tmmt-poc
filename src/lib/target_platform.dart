import 'dart:io';
import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';
import 'modelFacade.dart';

var fred = RuleBlock();

class TargetPlatform {
  late final StyleSheet _sheet;
  TargetPlatform(String cssFileName) {
    _sheet = css.parse(File(cssFileName).readAsStringSync());
    print(_sheet);
    var fred = _sheet.topLevels;
    print(fred.length);
    RuleSet bill = fred[3] as RuleSet;
    var sel = bill.selectorGroup?.selectors[0];
    var dec = bill.declarationGroup.declarations[0];
    print(sel);
    print(dec);
  }
  String evaluate(node, key) {
    return 'qqqqqq $key from platform';
  }
}
