
import 'dart:io';
import 'package:csslib/parser.dart';

class TargetPlatform {
  var _sheet;
  TargetPlatform(String cssFileName) {
    _sheet = parse(File(cssFileName).readAsStringSync());
    print(_sheet);
  }
  String evaluate(node,key) {
    return 'qqqqqq $key from platform';
  }
}