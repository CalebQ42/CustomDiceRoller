import 'dart:convert';
import 'dart:math';

import 'package:customdiceroller/cdr.dart';
import 'package:customdiceroller/dice/results.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'dice.g.dart';

@collection
class Die {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true, replace: true)
  String uuid = const Uuid().v4();

  @Index(unique: true)
  String title = "";
  List<Side> sides = [];
  DateTime lastSave = DateTime.now();

  @Ignore()
  bool saving = false;
  @Ignore()
  bool saveWaiting = false;
  @Ignore()
  String? driveId;

  Die({required this.title, this.sides = const []});
  Die.numberDie(int sides, AppLocalizations localizations) :
    title = localizations.dieNotation + sides.toString(),
    sides = List<Side>.generate(sides, (index) => Side.number(index+1));

  static Future<bool> importFromCloud(String id, CDR cdr) async{
    if(!cdr.prefs.drive() || cdr.driver == null || !await cdr.driver!.ready()) return false;
    var med = await cdr.driver!.getContents(id);
    if(med == null) return false;
    List<int> data = [];
    await for(var m in med.stream){
      data.addAll(m);
    }
    var json = const JsonDecoder().convert(String.fromCharCodes(data)) as Map<String, dynamic>;
    try{
      await cdr.db.writeTxn(() async => await cdr.db.dies.importJson([json]));
    }catch(e){
      return false;
    }
    return true;
  }

  //Load from the cloud. Must be re-pulled from the db for updated values
  Future<bool> cloudLoad(String id, CDR cdr) async{
    if(!cdr.prefs.drive() || cdr.driver == null || !await cdr.driver!.ready()) return false;
    var med = await cdr.driver!.getContents(id);
    if(med == null) return false;
    List<int> data = [];
    await for(var m in med.stream){
      data.addAll(m);
    }
    var json = const JsonDecoder().convert(String.fromCharCodes(data)) as Map<String, dynamic>;
    try{
      if(lastSave.isBefore(DateTime.fromMillisecondsSinceEpoch(json["lastSave"]))){
        await cdr.db.writeTxn(() async => await cdr.db.dies.importJson([json]));
      }
    }catch(e){
      return false;
    }
    return true;
  }

  List<Side> roll([int times = 1]) {
    var out = <Side>[];
    if(sides.isNotEmpty){
      var ran = Random();
      for(int i = 0; i < times; i++){
        out.add(sides[ran.nextInt(sides.length)]);
      }
    }
    return out;
  }

  DiceResults rollRes([int times = 1]){
    var res = DiceResults();
    res.addAll(roll(times), title);
    return res;
  }

  Future<void> save({CDR? cdr, BuildContext? context}) async{
    if(cdr == null){
      if(context == null) throw("MUST PROVIDE EITHER cdr or context!!!");
      cdr = CDR.of(context);
    }
    if(saving || saveWaiting) return;
    if(!saving){
      saving = true;
      lastSave = DateTime.now();
      cdr.db.writeTxn(() async => await cdr!.db.dies.put(this));
      await cloudSave(cdr);
      saving = false;
      if(saveWaiting) save(cdr: cdr);
    }else{
      saveWaiting = true;
    }
  }

  Future<bool> cloudSave(CDR cdr) async{
    if(!cdr.prefs.drive() || cdr.driver == null || !await cdr.driver!.ready()) return false;
    driveId ??= await getDriveId(cdr);
    if(driveId != null){
      var json = (await cdr.db.dies.where().idEqualTo(id).exportJson())[0];
      var data = const JsonEncoder().convert(json).codeUnits;
      return await cdr.driver!.updateContents(driveId!, Stream.value(data), dataLength: data.length);
    }
    return false;
  }

  Future<String?> getDriveId(CDR cdr) async{
    if(!cdr.prefs.drive() || cdr.driver == null || !await cdr.driver!.ready()) return null;
    var list = await cdr.driver!.listFiles("");
    if(list == null) return null;
    for(var fil in list){
      if(fil.name == uuid && fil.id != null) return fil.id;
    }
    return cdr.driver!.createFile(uuid);
  }

  // static Die of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DieHolder>()!.die;
}

@embedded
class Side{
  List<SidePart> parts;

  Side({this.parts = const []});
  Side.simple(String name) : parts = [SidePart(name: name)];
  Side.number(int value) : parts = [SidePart(value: value)];

  @override
  String toString() {
    var out = "";
    if(parts.isNotEmpty){
      for(var i = 0; i < parts.length; i++){
        if(parts[i].name == ""){
          out += "; ${parts[i].value}";
        }else if (parts[i].value == 1){
          out += "; ${parts[i].name}";
        }else{
          out += "; ${parts[i].value} ${parts[i].name}";
        }
      }
      out = out.substring(2);
    }
    return out;
  }
}

@embedded
class SidePart{
  int value;
  String name;

  SidePart({this.value = 1, this.name = ""});

  @override
  String toString(){
    var out = name;
    if(name != "") out += ": ";
    out += value.toString();
    return out;
  }
}

// class DieHolder extends InheritedWidget{

//   final Die die;

//   const DieHolder(this.die, {super.key, required super.child});

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
// }