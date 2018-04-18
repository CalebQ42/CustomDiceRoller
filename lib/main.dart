import 'package:flutter/material.dart';

void main() => runApp(new DiceStart());

class DiceStart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:"Custom Dice Roller",
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent
      ),
      home: new Scaffold(
        drawer: new Drawer(
          child: new Text("Hello")
        ),
        appBar: new AppBar(
          title: new Text("Custom Dice Roller")
        ),
        //body:
      )
    );
  }

}
