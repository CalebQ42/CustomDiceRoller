import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/Preferences.dart';
import 'package:customdiceroller/UI/Dice.dart';
import 'package:customdiceroller/UI/Groups.dart';
import 'package:customdiceroller/UI/Formula.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
  }catch (e){
    print(e);
  }
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
            // accentColor: Colors.deepOrangeAccent
        ),
        color: Colors.deepPurple,
        routes:{
          "/":(bc){
            switch(cdr.prefs.getString(Preferences.defaultRoute)){
              case "dice": return new Dice(cdr);
              case "groups": return new Groups(cdr);
              default: return new Formula(cdr);
            }
          },
          "/groups": (bc) => new Groups(cdr),
          "/formula":(bc)=> new Formula(cdr),
          "/dice":(bc)=>new Dice(cdr)
        },
        home: null,
    );
  }
}