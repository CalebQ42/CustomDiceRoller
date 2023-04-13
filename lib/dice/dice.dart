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

  Die({required this.title, this.sides = const []});
  Die.numberDie(int sides, AppLocalizations localizations) :
    title = localizations.dieNotation + sides.toString(),
    sides = List<Side>.generate(sides, (index) => Side.number(index+1));

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

  void save({CDR? cdr, BuildContext? context}){
    if(cdr == null){
      if(context == null) throw("MUST PROVIDE EITHER cdr or context!!!");
      cdr = CDR.of(context);
    }
    cdr.db.writeTxn(() async => await cdr!.db.dies.put(this));
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