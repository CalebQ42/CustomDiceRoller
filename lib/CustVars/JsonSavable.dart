import 'dart:io';
import 'dart:convert';

import 'package:customdiceroller/CDR.dart';

abstract class JsonSavable{
  
  var editing = false;
  var saving = false;

  JsonSavable();
  JsonSavable.fromJson(Map<String,dynamic> mp){
    load(mp);
  }

  void load(Map<String,dynamic> mp);
  Map<String,dynamic> toJson();
  JsonSavable clone();

  void saveJson(File f) => f.writeAsString(jsonEncode(this));
  void loadJson(String st) => load(jsonDecode(st));
  void stopEditing() => editing = false;
  //TODO: Add drive file getter of type DriveFile(CDR)
  void startEditing(NameGetter name, CDR cdr/*, DriveFileGetter dfg*/){
    if(!editing){
      editingLoop(name,cdr/*, dfg*/);
    }
  }

  void editingLoop(NameGetter name, CDR cdr/*, DriveFileGetter dfg*/) async{
    editing = true;
    var localFil = File(name(cdr));
    saveJson(localFil);
    if(cdr.prefs.getBool("GoogleDrive")){
      //Drive Save
    }
    var tmp = clone();
    while(editing){
      if(tmp!=this && !saving){
        saving = true;
        saveJson(localFil);
        if(cdr.prefs.getBool("GoogleDrive")){
          //Drive Save
        }
        tmp = clone();
        saving = false;
      }
      sleep(Duration(milliseconds: 300));
    }
    if(tmp!=this && !saving){
      saving = true;
      saveJson(localFil);
      if(cdr.prefs.getBool("GoogleDrive")){
        //Drive Save
      }
      tmp = clone();
      saving = false;
    }
  }
}

// typedef DriveFile DriveFileGetter(CDR cdr);
typedef String NameGetter(CDR cdr);