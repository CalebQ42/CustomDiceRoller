import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:flutter/material.dart';


void main(){
  var cdr = new CDR();
  cdr.initialize().whenComplete((){
    //check starting screen and show
    switch(cdr.prefs.getInt("defSecKey")){
      case 0:
        //TODO: Formula
        break;
      case 1:
        //TODO: Die
        break;
      case 2:
        //TODO: Dice
        break;
    }
    runApp(new DiceTestStart());
  });
}

class DiceTestStart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title:"Custom Dice Roller",
        theme: ThemeData.dark().copyWith(
            primaryColor: Colors.deepPurple,
            accentColor: Colors.deepOrangeAccent
        ),
        home: new Scaffold(
          drawer: new MyNavDrawer(),
          appBar: new MyAppBar(
            title: new Text("Custom Dice Roller"),
          ),
        )
    );
  }
}