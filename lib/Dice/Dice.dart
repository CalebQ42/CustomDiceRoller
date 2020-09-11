import 'dart:io';
import 'dart:math';

import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/JsonSavable.dart';
import 'package:customdiceroller/Dice/DiceResults.dart';
import 'package:customdiceroller/Dice/Sides.dart';

class Die extends JsonSavable{

  List<JsonSavable> sides;
  String _name;

  static String fileExtension = ".die";

  Die({String name,List<JsonSavable> sides}) : this.sides = sides ?? List();
  
  Die.numberDie(int sides) :
    _name = "D" + sides.toString(), 
    sides = List.generate(sides, (index) => SimpleSide((index+1).toString()));
  
  Die.fromJson(Map<String,dynamic> mp) : super.fromJson(mp);

  JsonSavable clone() =>
    Die(name: _name, sides: new List<JsonSavable>.from(sides));

  void load(Map<String, dynamic> mp) {
    _name = mp["name"];
    sides = new List<JsonSavable>();
    List<dynamic> jsonSides = mp["sides"];
    List<dynamic> isComplex = mp["isComplex"];
    for(int i = 0;i<jsonSides.length;i++){
      if(isComplex[i])
        sides.add(ComplexSide.fromJson(jsonSides[i]));
      else
        sides.add(SimpleSide.fromJson(jsonSides[i]));
    }
  }

  Map<String, dynamic> toJson() => {
    "name": _name,
    "sides": sides
  };

  bool isComplex(int i) => sides[i] is ComplexSide;

  ComplexSide getComplex(int i) => sides[i];

  SimpleSide getSimple(int i) => sides[i];

  int rollIndex() => new Random().nextInt(sides.length);

  String toString() => _name + " " + sides.toString();

  String localLocation(CDR cdr) => cdr.dir + "/" + _name.replaceAll(" ", "_")+fileExtension;

  //TODO: driveFile

  void delete(CDR cdr) => new File(localLocation(cdr)).deleteSync();

  void rename (String newName, CDR cdr){
    while(saving){
      sleep(new Duration(milliseconds: 200));
    }
    saving = true;
    new File(localLocation(cdr));
    _name = newName;
    saveJson(new File(localLocation(cdr)));
    saving = false;
  }
  
  void renameNoFileMove(String name) =>
    _name = name;

  String getName() => _name;
}

class Dice extends JsonSavable{

  List<Die> dice;
  String _name;

  static var fileExtension = ".dice";

  Dice.numberDice(int number,int sides) :
    _name = number.toString()+"D"+sides.toString(),
    dice = List.generate(number, (index) => Die.numberDie(sides));

  Dice({String name, List<Die> dice}) :
    _name = name,
    this.dice = dice ?? List();

  Dice.fromJson(Map<String,dynamic> mp):super.fromJson(mp);

  JsonSavable clone() => Dice(name: _name, dice: new List<Die>.from(dice));

  void load(Map<String, dynamic> mp) {
    _name = mp["name"];
    dice = new List<Die>();
    for(dynamic dy in mp["dice"])
      dice.add(Die.fromJson(dy));
  }

  Map<String, dynamic> toJson() => {
    "name": _name,
    "dice": dice
  };

  DiceResults roll(){
    var dr = DiceResults();
    dice.forEach((d){
      if(d.sides.length>0){
        var i = d.rollIndex();
        if(d.isComplex(i)){
          var c = d.getComplex(i);
          c.parts.forEach((p)=>dr.add(new Result(p.name,p.value), d.getName()));
          dr.addNum(c.number, d.getName());
        }else{
          var s = d.getSimple(i);
          if(s.isInt())
            dr.addNum(s.intSide(), d.getName());
          else
            dr.add(new Result(s.stringSide(),1), d.getName());
        }
      }
    });
    return dr;
  }

  String localLocation(CDR cdr) => cdr.dir + "/" + _name.replaceAll(" ", "_")+fileExtension;

  //TODO: driveFile

  void delete(CDR cdr) => new File(localLocation(cdr)).deleteSync();

  void rename (String newName, CDR cdr){
    while(saving){
      sleep(new Duration(milliseconds: 200));
    }
    saving = true;
    new File(localLocation(cdr));
    _name = newName;
    saveJson(new File(localLocation(cdr)));
    saving = false;
  }

  void renameNoFileMove(String name){
    _name = name;
  }

  String getName() => _name;
}