import 'dart:io';
import 'dart:convert';

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
  //TODO: void startEditing
}