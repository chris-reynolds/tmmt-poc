import 'dart:io';

import 'package:mini_parser/mini_parser_main.dart' as mini_parser;

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('Invalid usage: mini_parser filename');
    exit(16);
  }
  try {
    mini_parser.process(File(arguments[0]).readAsStringSync());
  } catch (e) {
    print('Exception: $e');
    exit(8);
  }
  print('Hello world: ${mini_parser.calculate()}!');
}
