import 'package:mini_parser/mini_parser_main.dart';
import 'package:test/test.dart';

void main() {
  test('skip calculate', () {
    expect(calculate(), 42);
  }, skip: true);
}
