import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/Preferences.dart';
import 'package:customdiceroller/UI/Dice.dart';
import 'package:customdiceroller/UI/Formula.dart';

import 'dart:async';

import 'package:flutter_crashlytics/flutter_crashlytics.dart';

import 'package:flutter/material.dart';

void main() async{
  bool isInDebugMode = false;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  await FlutterCrashlytics().initialize();
  runZoned<Future<Null>>(() async {
    var cdr = new CDR();
    cdr.initialize().whenComplete((){
      runApp(new DiceStart(cdr));
    });
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
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
            switch(cdr.prefs.getString(Preferences.defaultRoute)){
              case "dice": return new Dice(cdr);
              default: return new Formula(cdr);
            }
          },
          "/formula":(bc)=> new Formula(cdr),
          "/dice":(bc)=>new Dice(cdr)
        },
        home: null,
    );
  }
}