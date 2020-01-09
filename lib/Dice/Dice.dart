import 'dart:io';
import 'dart:math';

import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/JsonSavable.dart';
import 'package:customdiceroller/Dice/DiceResults.dart';
import 'package:customdiceroller/Dice/Sides.dart';

class Die extends JsonSavable{
  static String fileExtension = ".die";
  static Die numberDie(int sides){
    var d = Die("D"+sides.toString());
    for(int i = 1;i<=sides;i++){
      d.sides.add(SimpleSide(i.toString()));
    }
    return d;
  }

  List<JsonSavable> sides;
  String _name;

  Die([this._name = "New Die"]){
    sides = new List<JsonSavable>();
  }
  Die.withSides([this._name,this.sides]);
  Die.fromJson(Map<String,dynamic> mp):super.fromJson(mp);

  JsonSavable clone() => Die.withSides(_name,new List<JsonSavable>.from(sides));
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
  Map<String, dynamic> toJson() => {"name":_name,"sides":sides};
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
  void renameNoFileMove(String name){
    _name = name;
  }
  String getName() => _name;
}

class Dice extends JsonSavable{
  static var fileExtension = ".dice";
  static Dice numberDice(int number,int sides){
    var d = Dice(number.toString()+"D"+sides.toString());
    for(var i = 0;i<number;i++)
      d.dice.add(Die.numberDie(sides));
    return d;
  }

  List<Die> dice;
  String _name;

  Dice([this._name = "New Dice"]){
    dice = new List<Die>();
  }
  Dice.withDice(this._name,this.dice);
  Dice.fromJson(Map<String,dynamic> mp):super.fromJson(mp);

  JsonSavable clone() => Dice.withDice(_name,new List<Die>.from(dice));
  void load(Map<String, dynamic> mp) {
    _name = mp["name"];
    dice = new List<Die>();
    for(dynamic dy in mp["dice"])
      dice.add(Die.fromJson(dy));
  }
  Map<String, dynamic> toJson() => {"name":_name,"dice":dice};
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