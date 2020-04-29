import 'dart:io';
import 'dart:convert';


void main() async {
  try {
    var fred = (MModel('jobuniverse.json',systemName: 'blah'));
    print(fred._root['name']);
  } catch(ex) {
    print('Failed: $ex');
    exit(16);
  }
} // of main

class MModel {
  final fileName;
  MNode _root;
  MNode get root => _root; // readonly
  dynamic operator [](String value) => _root[value];
  
  MModel(this.fileName,{String systemName}) {
    var rootPackage;
    assert(File(fileName).existsSync());
    var contents = File(fileName).readAsStringSync();
    var model = json.decode(contents);
    var packages = model['packages'] ?? [];
    var systems = [];
    for (var package in packages) {
      var packageType = (package['stereoType']?? '').toLowerCase(); 
      if (packageType == 'product'  || packageType == 'system') {
        systems.add(package); 
      }
    }
    if (systemName == null) {
      rootPackage = systems.isNotEmpty ? systems.first : null;
    } else { // system name specified
      systems.where((system) => system['name'] == systemName).forEach((system) => rootPackage = system);
    }
    if (rootPackage == null) {
      throw("no system found ${fileName??''}  ${systemName??''}");
    }
    _root = deepWrap(rootPackage);
  }
} // of MModel

class MNode {
  Map<dynamic,dynamic> node;
  MNode(this.node);

  dynamic operator [](String value) => node[value];
} // of MNode



dynamic deepWrap(dynamic origin) {
  var result;
 if (origin is Map) {
    var newMap = origin.map((k1,v1)=>MapEntry(k1, deepWrap(v1)));
    result = MNode(newMap);
  }else   if (origin is Iterable) {
   result = origin.map((n)=>deepWrap(n)).toList();
 } else {
    result = origin;
  }
  return result;
}