import 'dart:io';
import 'dart:convert';


void main() async {
  var contents = File('jobuniverse.json').readAsStringSync();
  var model = json.decode(contents);
  print(model.toString());
  var newModel = deepWrap(model);
  print(newModel.toString());
} // of main

class MNode {
  Map<dynamic,dynamic> _node;
  MNode(this._node);
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