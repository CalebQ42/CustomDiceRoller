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

  String title = "";
  List<Side> sides = [];

  Die({this.title = "New Die", this.sides = const []});
  Die.numberDie(int sides, AppLocalizations localizations) :
    title = localizations.dieNotation + sides.toString(),
    sides = List<Side>.generate(sides, (index) => Side.number(index+1));

  DiceResults roll(){
    var res = DiceResults();
    res.add(sides[Random().nextInt(sides.length)]);
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
}

@embedded
class SidePart{
  int value;
  String name;

  SidePart({this.value = 1, this.name = ""});
}

// class DieHolder extends InheritedWidget{

//   final Die die;

//   const DieHolder(this.die, {super.key, required super.child});

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
// }