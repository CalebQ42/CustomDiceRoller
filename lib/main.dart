import 'dart:async';

import 'package:customdiceroller/cdr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() =>
  runZonedGuarded(
    () {
      CDR.initialize().then(
        (value) => runApp(
          CDRHolder(
            value,
            child: const MainUI()
          )
        )
      );
    },
    (error, stack) {
      if(kDebugMode){
        print(error);
        print(stack);
      }
    }
  );

class MainUI extends StatefulWidget{
  

  const MainUI({super.key});

  @override
  State<StatefulWidget> createState() => MainUIState();
}

class MainUIState extends State<MainUI>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Custom Dice Roller",
      home: Scaffold(
        body: Center(
          child: Text("yodle")
        ),
      )
    );
  }
}
