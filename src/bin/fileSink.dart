import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:poc/outputFile.dart';

void main() {
  var config = {};
  if (File('fileSink.config.yaml').existsSync()) {
    config = loadYaml(File('fileSink.config.yaml').readAsStringSync());
    if (config.containsKey('extensions')) {
      YamlMap fred = config['extensions'];
      fred.forEach((k,v) {
        OutputFile.extensions[k] = v;
      });
    }
  }

  OutputFile sink;
  print('started filesink');
  var line = stdin.readLineSync();
  while (line != null && line != 'zend') {
    if (line.startsWith('%output')) {
      if (sink != null) {
        sink.close;
        sink = null;
      }
      if (line.length>8) sink = OutputFile(line.substring(8).trim());
    } else {
      sink?.add(line);
    }
    line = stdin.readLineSync();
  } // of while
  sink?.close;
  print('ended filesink');
} // of main
