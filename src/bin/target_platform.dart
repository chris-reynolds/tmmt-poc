
import 'dart:io';
import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';

class TargetPlatform {
  StyleSheet _sheet;
  TargetPlatform(String cssFileName) {
    _sheet = css.parse(File(cssFileName).readAsStringSync());
    print(_sheet);
    var fred = _sheet.topLevels;
    print(fred.length);
  }
  String evaluate(node,key) {
    return 'qqqqqq $key from platform';
  }
}