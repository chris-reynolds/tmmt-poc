import 'dart:io';
import 'dart:convert';
import 'dart:collection';
import 'target_platform.dart';

class MModel {
  final fileName;
  MNode _root = MNode({}); // empty node as default
  MNode get root => _root; // readonly
  TargetPlatform? platform;
  dynamic operator [](String value) => _root[value];

  MModel(this.fileName, {String? systemName}) {
    var rootPackage;
    assert(File(fileName).existsSync());
    var contents = File(fileName).readAsStringSync();
    var model = json.decode(contents);
    var packages = model['packages'] ?? [];
    var systems = [];
    for (var package in packages) {
      var packageType = (package['stereoType'] ?? '').toLowerCase();
      if (packageType == 'product' || packageType == 'system') {
        systems.add(package);
      }
    }
    if (systemName == null) {
      rootPackage = systems.isNotEmpty ? systems.first : null;
    } else {
      // system name specified
      systems
          .where((system) => system['name'] == systemName)
          .forEach((system) => rootPackage = system);
    }
    if (rootPackage == null) {
      throw ("no system found ${fileName ?? ''}  ${systemName ?? ''}");
    }
    _root = deepWrap(rootPackage);
  }
} // of MModel

class MNode with MapMixin<String, dynamic> {
  MNode(Map<String, dynamic> orig) : _items = orig;
  final Map<String, dynamic> _items;
  @override
  bool containsKey(key) => true;
  @override
  Iterable<String> get keys => _items.keys;
  @override
  dynamic operator [](key) {
    if (_items.containsKey(key)) {
      return _items[key];
    }
    // todo platform lookup based on class, id or key
//    if ()
//    var result =
    return '??? $key   ????';
  }

  @override
  void operator []=(key, value) => _items[key] = value;
  @override
  void clear() => _items.clear();
  @override
  dynamic remove(dynamic key) => _items.remove(key);
}

dynamic deepWrap(dynamic origin) {
  var result;
  if (origin is Map) {
    var newMap = origin.map((k1, v1) => MapEntry<String, dynamic>(k1.toString(), deepWrap(v1)));
    result = MNode(newMap);
  } else if (origin is Iterable) {
    result = origin.map((n) => deepWrap(n)).toList();
  } else {
    result = origin;
  }
  return result;
}
