import 'package:flutter/material.dart';

void main() => runApp(new DiceStart());

class DiceStart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title:"Custom Dice Roller",
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepOrangeAccent
      ),
      home: new Scaffold(
        drawer: new Drawer(),
        appBar: new AppBar(
          title: new Text("Custom Dice Roller")
        ),
        body: new Center(
          child: new Text("Hello World")
        )
      )
    );
  }

}
