import 'dart:io';

import 'package:mini_parser/mini_parser_main.dart' as mini_parser;

void mainx(List<String> arguments) {
  if (arguments.length != 1) {
    print('Invalid usage: mini_parser filename');
    exit(16);
  }
  try {
    mini_parser.loadModel(File(arguments[0]).readAsStringSync());
  } catch (e) {
    print('Exception: $e');
    exit(8);
  }
}

void main(List<String> arguments) {
  var myRegexStr = '';
  var static1 = '''

''';
  var reg = RegExp(myRegexStr);
}
