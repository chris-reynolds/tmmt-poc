// file: Writer
// author: Chris Reynolds
// date: 21st November 2019

/// Purpose of this file
/// This will take a ModelFacade and a macro and process it.
/// producing an output string that can be processed in turn by
/// the file-sink.
/// We might ultimately use handlebars or m4 as the macro
/// processor.
/// *

//TASK: Load template from template parameter,S,W,2019-11-22
//TASK: Build lines array with sources,M,W,2019-11-22
//TASK: Process template with facade substitution,M,W,2019-11-22
//TASK: Implement static file include,M,W,2019-11-22
//TASK: Implement loop,L,W,2019-11-22
//TASK: Implement macro,L,W,2019-11-22

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