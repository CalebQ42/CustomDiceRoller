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
  bool cloudSaving = false;
  @Ignore()
  bool cloudSaveWaiting = false;
  @Ignore()
  String? driveId;

  List<String> get hints{
    var out = <String>[];
    for (var s in sides){
      for(var n in s.names){
        if(n == "") continue;
        if(!out.contains(n)) out.add(n);
      }
    }
    return out;
  }

  Die({required this.title, this.sides = const []});
  Die.numberDie(int sides, AppLocalizations localizations) :
    title = localizations.dieNotation + sides.toString(),
    sides = List<Side>.generate(sides, (index) => Side.number(index+1));
  Die.from(Die d) :
    title = d.title,
    sides = List.from(d.sides),
    lastSave = d.lastSave.copyWith();

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
      }else if(!lastSave.isAtSameMomentAs(DateTime.fromMillisecondsSinceEpoch(json["lastSave"]))){
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
      cloudSave(cdr);
      await cdr.db.writeTxn(() async => await cdr!.db.dies.put(this));
      saving = false;
      if(saveWaiting) save(cdr: cdr);
    }else{
      saveWaiting = true;
    }
  }

  Future<bool> cloudSave(CDR cdr) async{
    if(cloudSaving && cloudSaveWaiting) return false;
    if(!cdr.prefs.drive() || cdr.driver == null || !await cdr.driver!.ready()) return false;
    if(!cloudSaving){
      cloudSaving = true;
      driveId ??= await getDriveId(cdr);
      if(driveId == null){
        cloudSaving = false;
        if(cloudSaveWaiting) cloudSave(cdr);
        return false;
      }
      var json = (await cdr.db.dies.where().idEqualTo(id).exportJson())[0];
      var data = const JsonEncoder().convert(json).codeUnits;
      var res = await cdr.driver!.updateContents(
        driveId!,
        Stream.value(data),
        appProperties: <String, String>{
          "lastSave": lastSave.toIso8601String(),
        },
        dataLength: data.length
      );
      if(res){
        //Rate limit cloud saving to once every 3 seconds (Well technically 3 seconds + saving time).
        await Future.delayed(const Duration(seconds: 3));
      }
      cloudSaving = false;
      if(cloudSaveWaiting){
        cloudSave(cdr);
        cloudSaveWaiting = false;
      }
      return res;
    }else{
      cloudSaveWaiting = true;
    }
    return false;
  }

  Future<void> delete(BuildContext context, GlobalKey<AnimatedListState> listKey, int index) async{
    var cdr = CDR.of(context);
    var tmpD = Die.from(this);
    var mes = ScaffoldMessenger.of(context);
    await cdr.db.writeTxn(() async => await cdr.db.dies.delete(id));
    listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(sizeFactor: animation)
    );
    mes.clearSnackBars();
    mes.showSnackBar(SnackBar(
      content: Text(cdr.locale.dieDeleted),
      action: SnackBarAction(
        label: cdr.locale.undo,
        onPressed: () async{
          await cdr.db.writeTxn(() async => await cdr.db.dies.put(tmpD));
          listKey.currentState?.insertItem(index);
        },
      ),
    ));
    if(cdr.prefs.drive() && cdr.driver != null && await cdr.driver!.ready()){
      while(cloudSaving || cloudSaveWaiting){
        await Future.delayed(const Duration(milliseconds: 100));
      }
      driveId ??= await getDriveId(cdr);
      if(driveId != null){
        await cdr.driver!.delete(driveId!);
      }
    }
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
  List<SidePart> parts = List.empty(growable: true);

  List<String> get names => parts.map((e) => e.name).toList();

  Side();
  Side.simple(String name) : parts = [SidePart(name: name)];
  Side.number(int value) : parts = [SidePart(value: value)];
  Side.copy(Side s) : parts = List.from(List.from(s.parts));

  bool isSimple(){
    if(parts.isEmpty) return true;
    if(parts.length != 1) return false;
    if(parts[0].name == "") return true;
    if(parts[0].name != "" && parts[0].value == 1) return true;
    return false;
  }

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

  String editDisplayString(){
    var showAllNum = false;
    for(var i in parts){
      if(i.name != "" && i.value != 1){
        showAllNum = true;
        break;
      }
    }
    var out = "";
    if(parts.isNotEmpty){
      for(var i = 0; i < parts.length; i++){
        if(parts[i].name == ""){
          out += "\n${parts[i].value}";
        }else if (!showAllNum){
          out += "\n${parts[i].name}";
        }else{
          out += "\n${parts[i].value} ${parts[i].name}";
        }
      }
      out = out.substring(1);
    }
    return out;
  }
}

@embedded
class SidePart{
  int value;
  String name;

  SidePart({this.value = 1, this.name = ""});

  String nameOrValue(){
    if(name == "") return value.toString();
    return name;
  }

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