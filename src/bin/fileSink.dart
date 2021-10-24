import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:poc/outputFile.dart';

String CONFIG_FILE = 'fileSink.config.yaml';
void main(List<String> args) {
  bool testMode = false;
  int testLine = 0;
  var config = {};
  if (File(CONFIG_FILE).existsSync()) {
    config = loadYaml(File(CONFIG_FILE).readAsStringSync());
    if (config.containsKey('extensions')) {
      YamlMap fred = config['extensions'];
      fred.forEach((k, v) {
        OutputFile.extensions[k] = v;
      });
    }
    testMode = config.containsKey('test');
  }
  String? readLine() {
    if (testMode) {
      return testLine < args.length ? args[testLine++] : null;
    } else
      return stdin.readLineSync();
  } // of readLine

  OutputFile? sink;
  print('started filesink');
  var line = readLine();
  while (line != null && line != '%zend') {
    if (line.startsWith(OutputFile.OPEN_CODE)) {
      if (sink != null) {
        sink.close;
        sink = null;
      }
      if (line.length > OutputFile.OPEN_CODE.length + 1)
        sink = OutputFile(line.substring(8).trim());
    } else {
      sink?.add(line);
    }
    line = readLine();
  } // of while
  sink?.close;
  print('ended filesink');
} // of main
