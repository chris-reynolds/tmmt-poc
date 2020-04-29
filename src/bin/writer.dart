import 'dart:io';
import 'package:mustache_template/mustache_template.dart';
import 'mmodel.dart';


class Writer {
    final String platform;
    Template _template;
    MModel model;

    Writer(String fileName, {this.model,this.platform}) {
      var contents  = File(fileName).readAsStringSync();
      _template = Template(contents,name: fileName);
    }

  String render() => _template.renderString(model.root.node);

} // of Writer