// file: File-Sink
// author: Chris Reynolds
// date: 21st November 2019

/// *  Purpose of this file
///  * This takes the contents and writes it to an output file
///  * In general the text stream is written to the
///  * nominated file.
///  * Requirement Statments:
///  * 1. Write contents to new file.
///  * 2. Only write to existing file if contents have changed.
///  * 3. Protect custom code blocks.
///  * 4. Insert codegen blocks.
///  * 5. Allow custom code blocks to be initialised.
///  * 6. Backup original file if required.
///  * *

//TASK: Write contents to new file,S,T,2019-11-22,2019-12-29
//TASK: Only write to existing file if contents have changed,S,T,2019-11-22,2019-12-29
//TASK: Protect custom code blocks,M,T,2019-11-22,2019-12-29
//TASK: Insert codegen blocks,M,W,2019-11-22
//TASK: Allow custom code blocks to be initialised,M,W,2019-11-22
//TASK: Backup original file if required,M,W,2019-11-22
import 'dart:io';
import 'package:path/path.dart' as path;

class OutputFile {
//  static const PREFIX = '%';
//  static const OUTPUT_COMMAND = '${prefix}output';
  static Map<String, String> extensions = {'default': '//'};
  static String CUSTOM_CODE = 'customcode';
  static String OPEN_CODE = '%output';
  String commentStart = '';
  String commentEnd = '';
  String startMarker = '';
  String endMarker = '';
  late String _contents;
  String fileName;
  bool backup;
  late final String _prefix;

  OutputFile(this.fileName, {this.backup = false, String contents = '', String prefix = '%'}) {
    _prefix = prefix;
    _contents = contents;
    var ext = path.extension(fileName);
    if (ext.length > 0) ext = ext.substring(1); //trip dot
    if (!extensions.containsKey(ext)) {
      ext = 'default';
    }
    var bits = extensions[ext]?.split('..') ?? ['//']; // default is double slash
    commentStart = bits[0];
    commentEnd = bits.length > 1 ? bits[1] : '';

    startMarker = '$commentStart                                  \'*** Start $CUSTOM_CODE';
    endMarker = '$commentStart                                  \'*** End $CUSTOM_CODE';
  } // of constructor

  void add(String s) => _contents += s + '\n';

  Map<String, String> extractCodeBlocks(String allLines) {
    var result = <String, String>{};
    var currentBlockName = '';
    allLines.split(endMarker).forEach((codeBlock) {
      var bits = codeBlock.split(startMarker);
      if (bits.length > 1) {
        var nameAndCode = bits[1];
        var delimPos = nameAndCode.indexOf('$commentEnd\n');
        currentBlockName = nameAndCode.substring(0, delimPos).trim().toLowerCase();
        result[currentBlockName] = nameAndCode.substring(delimPos + 1 + commentEnd.length);
      }
    });
    return result;
  } // of buildCodeBlocks

  String compactCustomBlocks(String allLines) {
    var result = '';
    var currentBlockName = '';
    var sections = allLines.split(endMarker);
    for (var i = 0; i < sections.length; i++) {
      var bits = sections[i].split(startMarker);
      result += bits[0];
      if (bits.length > 1) {
        var nameAndCode = bits[1];
        var delimPos = nameAndCode.indexOf('$commentEnd\n');
        currentBlockName = nameAndCode.substring(0, delimPos).trim().toLowerCase();
        result += '$_prefix$CUSTOM_CODE $currentBlockName\n';
      }
    }
    return result;
  } // of compactCustomBlocks

  String expandCustomBlocks(String contents, Map<String, String> blocks) {
    var sections = contents.split('$_prefix$CUSTOM_CODE');
    for (var i = 1; i < sections.length; i++) {
      //skip first section as it is the start of the file
      var delimPos = sections[i].indexOf('\n'); // get end of line
      var blockName = sections[i].substring(0, delimPos).trim().toLowerCase();
      sections[i] = writeBlock(blockName, blocks) + sections[i].substring(delimPos + 1);
    }
    return sections.join('');
  } // of expandCustomBlocks

  String writeBlock(String blockName, Map<String, String> blocks) {
    var result = '$startMarker $blockName $commentEnd\n';
    result += blocks[blockName.toLowerCase()] ?? ''; //blank if non-existant
    result += '$endMarker $blockName $commentEnd\n';
    return result;
  }

  bool get close {
    var expandedContents;
    if (File(fileName).existsSync()) {
      var oldContents = File(fileName).readAsStringSync();
      var oldCodeBlocks = extractCodeBlocks(oldContents);
      expandedContents = expandCustomBlocks(_contents, oldCodeBlocks);
      if (oldContents == expandedContents) {
        print('skipped ${File(fileName).path}');
        return false;
      }
    } else {
      // first time write
      expandedContents = expandCustomBlocks(_contents, {});
    }
    if (backup) {
      // todo improve the write with a backup
    }
    File(fileName).writeAsStringSync(expandedContents);
    print('written ${File(fileName).path}');
    return true;
  } // of close
}
