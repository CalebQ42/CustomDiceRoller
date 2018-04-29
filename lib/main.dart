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
          title: new Text("Custom Dice Roller"),
          actions:[
            new PopupMenuButton(
              itemBuilder: (context)=>[
                PopupMenuItem(
                  value: "G+",
                  child: const Text("G+ Community")
                ),
                PopupMenuItem(
                  value: "Translate",
                  child: const Text("Help Translate!")
                )
              ],
              onSelected:(t){
                var txt = t as String;
                switch(txt){
                  case "G+":
                    //TODO: Find not brokne thing
                    break;
                  case "Translate":
                    //TODO: Find not brokne thing
                    break;
                }
              }
            )
          ]
        ),
      )
    );
  }
}