import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:customdiceroller/Dice/Dice.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CDR{
  SharedPreferences prefs;
  String dir;
  List<Die> _dieMaster;
  List<Dice> _diceMaster;
  PackageInfo packageInfo;

  Future<void> initialize() async {
    var dir = await getApplicationDocumentsDirectory();
    this.dir = dir.path.substring(0,dir.path.indexOf("app_flutter"))+"Dice";
    this.prefs = await SharedPreferences.getInstance();
    this.packageInfo = await PackageInfo.fromPlatform();
    var dirDir = new Directory(this.dir);
    if(!dirDir.existsSync())
      dirDir.create(recursive: true);
    loadBoth();
  }

  List<Die> getDies(String str){
    _dieMaster.sort((a,b)=> a.getName().compareTo(b.getName()));
    if(str=="")
      return _dieMaster;
    return new List.of(_dieMaster.where((d)=>d.getName().contains(str)));
  }
  void removeDieAt(String str, int i){
    var d = getDies(str)[i];
    d.delete(this);
    _dieMaster.remove(d);
  }
  Die addNewDie(){
    var newy = Die();
    var i = 1;
    while(_dieMaster.any((d)=>d.getName()==newy.getName())){
      newy.renameNoFileMove("New DiehasConflictDie " + i.toString());
    }
    _dieMaster.add(newy);
    return newy;
  }
  bool hasConflictDie(String name){
    return _dieMaster.any((d)=>d.getName() == name);
  }
  void loadDie(){
    _dieMaster = new List();
    new Directory(dir).listSync().forEach((fse){
      if(fse.path.endsWith(".die")){
        _dieMaster.add(new Die.fromJson(jsonDecode(new File(fse.path).readAsStringSync())));
      }
    });
  }

  void loadBoth(){
    _diceMaster = new List();
    _dieMaster = new List();
    new Directory(dir).listSync().forEach((fse){
      if(fse.path.endsWith(".dice")){
        _diceMaster.add(new Dice.fromJson(jsonDecode(new File(fse.path).readAsStringSync())));
      }else if(fse.path.endsWith(".die")){
        _dieMaster.add(new Die.fromJson(jsonDecode(new File(fse.path).readAsStringSync())));
      }
    });
  }

  List<Dice> getDice(String str){
    _diceMaster.sort((a,b)=>a.getName().compareTo(b.getName()));
    if(str=="")
      return _diceMaster;
    return new List.of(_diceMaster.where((d)=>d.getName().contains(str)));
  }
  void removeDiceAt(String str,int i){
    var d = getDice(str)[i];
    d.delete(this);
    _diceMaster.remove(d);
  }
  Dice addNewDice(){
    var newy = Dice();
    var i = 1;
    while(_diceMaster.any((d)=>d.getName()==newy.getName())){
      newy.renameNoFileMove("New Dice " + i.toString());
    }
    _diceMaster.add(newy);
    return newy;
  }
  bool hasConflictDice(String name){
    return _diceMaster.any((d)=>d.getName()==name);
  }
  void loadDice(){
    _diceMaster = new List();
    new Directory(dir).listSync().forEach((fse){
      if(fse.path.endsWith(".dice")){
        _diceMaster.add(new Dice.fromJson(jsonDecode(new File(fse.path).readAsStringSync())));
      }
    });
  }
}