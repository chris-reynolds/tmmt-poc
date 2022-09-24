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

String _between(String source, String openDelim, String closeDelim) {
  final int openDelimPos = source.indexOf(openDelim);
  final int closeDelimPos = source.lastIndexOf(closeDelim);
  if (openDelimPos >= 0 && closeDelimPos >= 0 && openDelimPos < closeDelimPos) {
    return source.substring(openDelimPos + 1, closeDelimPos).trim();
  } else {
    throw Exception('Missing delimiters for $source');
  }
} // of _between

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
  const rxQuotedString = r'\"[^\"\n]*\"';
  const rxUnQuoted = r'\w+';
  const rxValue = '(?<val>($rxQuotedString|$rxUnQuoted))';
  const rxSlackComma = r'\s*\,\s*';
  const rxSlackAssign = r'\s*\=\s*';
  const rxNameValue = '$rxName$rxSlackAssign$rxValue';
  test('Static3', () {
    String myReg = '$rxKeyword' r'(?:\s*\:)';
    String myNameProp = '$rxName$rxOptSpace$rxOptParameters';
    //'$rxName$rxOptSpace';
    var regExp =
        RegExp(myReg, multiLine: true, dotAll: true, caseSensitive: false);
    var regNameProp =
        RegExp(myNameProp, multiLine: true, dotAll: true, caseSensitive: false);
    var regNameValue = RegExp(rxNameValue,
        multiLine: true, dotAll: true, caseSensitive: false);

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
        var arrayContents = _between(item['value'] as String, '[', ']');

        matches = regNameProp.allMatches(arrayContents);
        print('AAAAAAAAAAAAA $arrayContents BBBBBBBBBBBBBB ${matches.length}');
      } else {
        // process single
        matches = regNameProp.allMatches(item['value']);
        for (final m in matches) {
          for (final nm in m.groupNames) {
            print('group is $nm = ${m.namedGroup(nm)}');
            item[nm] = m.namedGroup(nm) ?? '';
            if (nm == 'proplist' && item[nm] != '') {
              List<dynamic> myProps = [];
              var nameval = regNameValue.allMatches(m.namedGroup(nm) ?? '');
              for (final prop in nameval) {
                var aname = prop.namedGroup('name');
                var aval = prop.namedGroup('val');
                myProps.add({'n': aname, 'v': aval});
              }
              item['proplist'] = myProps.toString();
            }
          }
        }
      }
    }
    print('myList: $myList');
    expect(1, 1);
  }, skip: false);
  test('Static3x', () {}, skip: true);
}
