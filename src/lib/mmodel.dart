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
    _root = MNode({'root': true}).deepWrap(rootPackage);
  }
} // of MModel

class MNode with MapMixin<String, dynamic> {
  MNode? parent;
//  List<MNode> _children = [];
  MNode(Map<String, dynamic> orig) : _items = orig {
//    parent?._children.add(this);
  }
  final Map<String, dynamic> _items;
  @override
  bool containsKey(key) => true;
  @override
  Iterable<String> get keys => _items.keys;
  @override
  dynamic operator [](key) {
    dynamic result = '';
    if (!(key is String) || key == '') return '??? Empty key ???';
    // separate out any text tranforms
    var bits = key.split('|');
    var fieldName = bits[0].trim();
    var targetName = '';
    var delimPos = fieldName.indexOf('=');
    if (delimPos > 0) {
      targetName = left(fieldName, delimPos);
      fieldName = fieldName.substring(delimPos + 1);
    }
    //for (int i = 0; i < bits.length; i++) bits[i] = bits[i].trim();
    if (_items.containsKey(fieldName))
      result = _items[fieldName];
    else
      result = parentKey(fieldName);
    if (result == '') {
      return '??? ${fieldName}   ????';
    }
    // check if it is a list and return without transform
    if (result is List) return result;
    for (int i = 1; i < bits.length; i++) {
      switch (bits[i].trim().toLowerCase()) {
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
        case 'prefix':
          var lines = (result ?? '').split('\n');
          result = '--  ' + lines.join('--  ');
          break;
        default:
      } // of switch
    } // of transform for-loop
    if (targetName.isNotEmpty) this._items[targetName] = result;
    return result;
  } // get property

  dynamic parentKey(String key) => parent?[key] ?? parent?.parentKey(key);

  @override
  void operator []=(key, value) => _items[key] = deepWrap(value);
  @override
  void clear() => _items.clear();
  @override
  dynamic remove(dynamic key) => _items.remove(key);

  dynamic deepWrap(dynamic origin) {
    var result;
    if (origin is Map) {
      result = MNode({});
      origin.forEach((k1, v1) {
        result[k1.toString()] = v1;
      });
      result.parent = this;
    } else if (origin is Iterable) {
      result = <MNode>[];
      origin.forEach((n) {
        var newValue = deepWrap(n);
        result.add(newValue);
        if (newValue is MNode) {
          newValue.parent = this;
        }
      });
    } else {
      result = origin;
    }
    return result;
  } // of deepwrap
} // of MNode



