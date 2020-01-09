import 'dart:io';

import 'package:customdiceroller/CDR.dart';
import 'package:flutter/services.dart' show rootBundle;

const List<String> testFiles = ["Testing_1.die","Testing_2.die","Testing_1.dice"];

void setupTesting(CDR cdr) async{
  for(String st in testFiles){
    String json = await rootBundle.loadString("assets/"+st);
    File testFile = File(cdr.dir+"/"+st);
    if(testFile.existsSync())
      testFile.deleteSync();
    testFile.writeAsStringSync(json);
  }
}