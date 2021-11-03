import 'dart:io';
import 'dart:convert';
import 'dart:collection';
import 'target_platform.dart';
import 'StringUtils.dart';

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
      if (packageType == 'product' || packageType.contains('system')) {
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
    String result = '';
    if (!(key is String) || key == '') return '??? Empty key ???';
    // separate out any text tranforms
    var bits = key.split('|');
    for (int i = 0; i < bits.length; i++) bits[i] = bits[i].trim();
    if (!_items.containsKey(bits[0])) {
      return '??? ${bits[0]}   ????';
    }
    // check if it is a list and return without transform
    if (_items[bits[0]] is List) return _items[bits[0]];
    result = _items[bits[0]];
    for (int i = 1; i < bits.length; i++) {
      switch (bits[i]) {
        case '1u':
          result = firstUpper(result);
          break;
        case '1l':
          result = firstLower(result);
          break;
        case 'lc':
          result = result.toLowerCase();
          break;
        case 's':
          result = plural(result);
          break;
        default:
      } // of switch
    } // of transform for-loop
    return result;
  } // get property

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
