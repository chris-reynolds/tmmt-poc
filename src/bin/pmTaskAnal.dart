/*
This is a dailyscanner program to pick up metrics for project control
Author: chris Reynolds
Date: 29th March 2019
 */

import 'dart:io';
import 'package:path/path.dart' as path;

final String DELIMITER = ',';
final DateTime STARTDATE = DateTime(2019,11,21);
final DateTime ENDDATE = DateTime(2020,4,1);
final int PROJECTDURATION = ENDDATE.difference(STARTDATE).inDays;


void main(List<String> args) async {
  if (args.isNotEmpty && Directory(args[0]).existsSync()) {
    Directory.current = args[0];    
  }
  var loc = await directoryLinesOfCode('src');
  var bugFile = CSVFile('planning/bug_list.csv');
  var bugList = Bug.loadBugs(bugFile.lines);
  var bugOsCount = bugList.where((bug) => bug.isOutstanding).length;
  var taskFile = CSVFile('planning/tmp_tasks.txt',hasTitles: false);
  var taskList = Task.loadTasks(taskFile.lines);
  var totalTaskSize = 0;
  var totalTaskOutstanding = 0.0;
  for (var task in taskList) {
    totalTaskSize += task.sizeInUnits;
    totalTaskOutstanding += task.outstandingInUnits;
  }
  addToFile('planning/metrics.log', ',$loc,${taskList.length},$totalTaskSize,$totalTaskOutstanding,${bugList.length},$bugOsCount,0,0,0,0');
  //if (DateTime.now().weekday == DateTime.saturday)
    Task.saveCarPark(taskList);
} // of main

String pad(String s,int width) {
  return '$s                                                            '.substring(0,width);
} // of pad

double timeSpentRatio() => DateTime.now().difference(STARTDATE).inDays/PROJECTDURATION;

String displayPair(double doneQty,double totalQty) {
  var percentage = (doneQty*100/totalQty).round();
  return '${doneQty.round()}/${totalQty.round()} = $percentage%';
} // of displayPair

class CSVFile {
  List<String> columnNames;
  List<String> lines = [];
  CSVFile(String filename,{bool hasTitles=true}) {
    lines = File(filename).readAsStringSync().split('\n');
    if (lines.isEmpty) {
      throw Exception('CSV Files need at least one line for the header');
    }
    columnNames = lines[0].split(',');
    if (hasTitles) lines.removeAt(0);
  } // of constructor

} // of CSVFile


class Bug {
  String number;
  String description;
  String severity = 'M';   // high/medium/low
  DateTime created;
  DateTime closed;

  static List<Bug> loadBugs(List<String> lines) {
    var result = <Bug>[];
    for (var lineIx=0 ; lineIx<lines.length; lineIx++) {
      if (lines[lineIx].isNotEmpty) {
        try {
          result.add(Bug.fromLine(lines[lineIx].split(DELIMITER)));
        } catch(ex) {
          throw Exception('Failed on bug line ${lineIx+1} with error $ex');
        }
      }
    }
    return result;
  } // loadBugs

  Bug.fromLine(List<String> thisLine) {
    number = thisLine[0];
    description = thisLine[1];
    if (thisLine.length>2  && thisLine[2].isNotEmpty ) {
      severity = thisLine[2]  ?? '';
    }
    if (thisLine.length>3) {
      created = DateTime.parse(thisLine[3]);
    }
    if (thisLine.length>4  && thisLine[4].isNotEmpty) {
      closed =  DateTime.parse(thisLine[4]);
    }
  } // of constructor from Line
  bool get isOutstanding => closed == null;
}

class Task {
  String description;
  String size ='M';   // big,medium,small
  String progress = 'W';  // waiting,inprogress,testing,finished,cancelled
  String group;
  DateTime plannedOn;
  DateTime startedOn;
  DateTime finishedOn;

  static List<Task> loadTasks(List<String> lines) {
    var result = <Task>[];
    for (var lineIx=0 ; lineIx<lines.length; lineIx++) {
      if (lines[lineIx].isNotEmpty) {
        try {
          result.add(Task.fromLine(lines[lineIx].replaceAll(':',',').split(',')));
        } catch(ex) {
          throw Exception('Failed on task line ${lineIx+1} with error $ex');
        }
      }
    }
    return result;
  } // loadTasks
  
  Task.fromLine(List<String> thisLine) {
    if (thisLine.length<6) {
      throw ('Insufficient fields in task line ($thisLine)');
    }
    group = path.basenameWithoutExtension(thisLine[0]);
    description = thisLine[2].trim();
    // check for group.description syntax
    var delimPos = description.indexOf('\.');
    if (delimPos>1) {
      group = description.substring(0,delimPos);
      description = description.substring(delimPos);
    } 
    size = thisLine[3].toUpperCase() ?? 'M';
    progress = thisLine[4].toUpperCase() ?? 'W';
    if (thisLine[5].isNotEmpty) {
      plannedOn =  DateTime.parse(thisLine[5]);
    }    
    if (thisLine.length>6  && thisLine[6].isNotEmpty) {
      startedOn =  DateTime.parse(thisLine[6]);
    }   
    if (thisLine.length>7  && thisLine[7].isNotEmpty) {
      finishedOn =  DateTime.parse(thisLine[7]);
    }
  } // of constructor from Line
  bool get isDone => finishedOn != null;
  int get sizeInUnits {
    if (size=='L') return 9;
    if (size=='M') return 3;
    if (size=='S') return 1;
    throw Exception('Invalid task size($size) - $description');
  } // of sizeInUnits

  int get progressInPercent {
    // waiting,inprogress,testing,finished
    if (finishedOn != null) return 100;  // has a finshedOnDate
    if (progress=='D') return 10;
    if (progress=='I') return 20;
    if (progress=='T') return 80;
    if (progress=='F') return 100;
    return 0;
  } // progressInUnits

  double get outstandingInUnits {
    return sizeInUnits*(1-0.01*progressInPercent);
  } // of outstandingInUnits

  static void saveCarPark(List<Task> taskList) {
    var filename = 'planning/carpark'+DateTime.now().toString().substring(0,10)+'.log'; // todo : add date to filename
    var sections = [];
    var totalSize = 0.0, totalDone = 0.0;
    for (var task in taskList) {
      if (task.group.isNotEmpty || task.sizeInUnits > 0) {
        var foundSectionIx = -1;
        for (var sectionIx = 0; sectionIx < sections.length; sectionIx++) {
          if (sections[sectionIx][0] == task.group) {
            foundSectionIx = sectionIx;
          }
        }
        if (foundSectionIx == -1) {
          sections.add([task.group, 0.0, 0.0]);
          foundSectionIx = sections.length - 1; // point to last item
        }
        sections[foundSectionIx][1] += task.sizeInUnits;
        sections[foundSectionIx][2] += task.sizeInUnits- task.outstandingInUnits;
        totalSize += task.sizeInUnits;
        totalDone += task.sizeInUnits-task.outstandingInUnits;
      }
    }
    var todo = '--------------------------------------------------------------------';
    var done = '*********************************************************************';
    var logFile = File(filename).openWrite();
    for (var section in sections) {
      logFile.writeln('${pad(section[0],20)}'+done.substring(0,(section[2]).round())+
           todo.substring(0,(section[1]-section[2]).round())+pad('',60-section[1].round())+displayPair(section[2], section[1]));
    }
    logFile.writeln();
    logFile.writeln('${pad('              ',72)}'+displayPair(totalDone, totalSize));
    logFile.writeln('Velocity = ${((totalDone/totalSize)*100/timeSpentRatio()).round()}% '
        'needed to finish by ${ENDDATE.toString().substring(0,10)}');
    logFile.close();
  } // saveCarPark
}  // of Task

void addToFile(String filename,String contents,{bool timestamp=true}) {
  var _timestampStr = '';
  if (timestamp) {
    _timestampStr = DateTime.now().toString()+' ';
  }
  try {
    var file = File(filename);
    file.openWrite(mode: FileMode.append)
      ..writeln('$_timestampStr$contents')
      ..close();
  } catch(ex) {
    print(ex.toString());
  }
} // of addToFile

Future<int> directoryLinesOfCode(String rootDir) async {
  var result = 0;
  var dir = Directory(rootDir);
  var fseList = dir.listSync(recursive: true);
  for (var fse in  fseList) {
    var type = await FileSystemEntity.type(fse.path);
    if (type == FileSystemEntityType.file  && fse.path.length>6 &&
        fse.path.substring(fse.path.length-5)=='.dart') {
      result += fileLinesOfCode(fse as File);
    }
  } // of file loop
  return result;
} // of lines of code

int fileLinesOfCode(File thisFile) {
  var contents = thisFile.readAsStringSync();
  // remove multiline comments
  var tempList = contents.split('\/\*');
  for (var ix = 0 ; ix<tempList.length; ix++) {
    var terminator = tempList[ix].indexOf('\*\/');
    if (terminator>0) {
      tempList[ix] = tempList[ix].substring(terminator+2);
    } // todo check for contig multi comments
  }
  var lines = tempList.join().split('\n');
  // loop backwards so we can delete lines cleanly
  for (var ix=lines.length-1; ix>=0; ix--) {
    var thisLine =  lines[ix].trim();
    if (thisLine.isEmpty  || (thisLine.length>2 && thisLine.substring(0,2) == '//')) {
      lines.removeAt(ix);
    }
  }
  return lines.length;
} // of fileLinesOfCode






