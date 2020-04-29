// file: Macro Processor
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

import 'package:mustache_template/mustache_template.dart';

void main_test() {
  var source = '''
	  {{# names }}
            <div>{{ lastname }}, {{ firstname }}z	  {{/ names }}
	  {{^ names }}
	    <div>No names.</div>
	  {{/ names }}
    {{ address.line1 }}
	  {{! I am a comment. }}
	''';

  var template = Template(source, name: 'template-filename.html');

  var output = template.renderString({
    'names': [
      {'firstname': 'Greg', 'lastname': 'Lowe'},
      {'firstname': 'chris', 'lastname': 'reynolds'},
      {'firstname': 'Bob', 'lastname': 'Johnson'}
    ],
    'address': {'line1': 'Omokoroa Rd'}
  });

  print(output);
}
