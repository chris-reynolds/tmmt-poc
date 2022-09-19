//import 'package:mini_parser/mini_parser_main.dart';
import 'package:test/test.dart';

const STATIC1 = '''
    Application: Todo   
        Entity: Task   
            Attribute: [Description\$,DueDate@,IsDone!] ''';

const STATIC2 = '''
    Application: Todo   
        Entity: Task   
            Attribute: [Description,DueDate,IsDone] ''';

const STATIC3 = '''
    Application: Todo   
        Entity: Task (plural=Taskies, bill=2 )  
            Attribute : [Description,DueDate,IsDone,TaskGroup]
            Attribute: fred
        Entity: TaskGroup
            Attribute: [
               Name,
               Tasks]  
''';

void main() {
  // Map<String, Object> model;
  test('Static1', () {
//    model = loadModel(STATIC1);
//    expect(1, model.walk('type=Application'));
  }, skip: true);

  // \b(?P<kw>(Application|entity|Attribute))(?:\s*\:\s*)((?P<nm>(\w+))\s?(?P<attrs>(\(\s*[^\)]*\s*\)))?|(?P<array>(\[([^\]]|\n)+\])))

  const rxKeyword = r'\b(?<kw>(Application|entity|Attribute))';
  const rxOptSpace = r'\s*';
  const rxOptParameters = r'(\(\s*(?<proplist>[^\)]+)\s*\))?';
  const rxName = r'(?<name>(\w+))';
  test('Static3', () {
    String myReg = '$rxKeyword' r'(?:\s*\:)';
    String myNameProp = '$rxName$rxOptSpace$rxOptParameters';
    //'$rxName$rxOptSpace';
    var regExp =
        RegExp(myReg, multiLine: true, dotAll: true, caseSensitive: false);
    var regNameProp =
        RegExp(myNameProp, multiLine: true, dotAll: true, caseSensitive: false);
    int uptoChar = 0;
    String keyword = '';
    List<dynamic> myList = [];
    var matches = regExp.allMatches(STATIC3);
    for (final m in matches) {
      if (uptoChar > 0) {
        var value = STATIC3.substring(uptoChar + 1, m.start - 1).trim();
        myList.add({'keyword': keyword, 'value': value});
      }
      uptoChar = m.end;
      keyword = m.namedGroup('kw') ?? '';
    }
    var lastValue = STATIC3
        .substring(
          uptoChar + 1,
        )
        .trim();
    myList.add({'keyword': keyword, 'value': lastValue});
    for (var item in myList) {
      if ((item['value'] as String).startsWith('[')) {
        // process array
      } else {
        // process single
        matches = regNameProp.allMatches(item['value']);
        for (final m in matches) {
          for (final nm in m.groupNames) {
            print('group is $nm = ${m.namedGroup(nm)}');
            item[nm] = m.namedGroup(nm) ?? '';
          }
        }
      }
    }
    print('myList: $myList');
    expect(1, 1);
  }, skip: false);
  test('Static3x', () {}, skip: true);
}
