import 'dart:io';
import 'package:mustache_template/mustache_template.dart';
import 'mmodel.dart';

class Writer {
  final String? platform;
  late final Template _template;
  final MModel model;

  Writer(String fileName, {required this.model, this.platform}) {
    var contents = File(fileName).readAsStringSync();
    _template = Template(contents, name: fileName, lenient: false);
  }

  String render() => _template.renderString(model.root);
} // of Writer