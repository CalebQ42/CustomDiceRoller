import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/UI/Dice.dart';
import 'package:customdiceroller/UI/Formula.dart';
import 'package:flutter/material.dart';


void main(){
  var cdr = new CDR();
  cdr.initialize().whenComplete((){
    runApp(new DiceStart(cdr));
  });
}

class DiceStart extends StatelessWidget{
  final CDR cdr;
  DiceStart(this.cdr);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Custom Dice Roller",
        theme: ThemeData.dark().copyWith(
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepOrangeAccent
        ),
        color: Colors.deepPurple,
        routes:{
          "/":(bc){
            switch(cdr.prefs.getString("default")){
              case "dice": return new Dice(cdr,bc);
              default: return new Formula(cdr,bc);
            }
          },
          "/formula":(bc)=> new Formula(cdr,bc),
          "/dice":(bc)=>new Dice(cdr,bc)
        },
        home: null,
    );
  }
}