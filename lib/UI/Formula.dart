import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/UI/Common.dart';
import 'package:flutter/material.dart';

class Formula extends StatelessWidget{
  final CDR cdr;
  final BuildContext context;
  Formula(this.cdr, this.context);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice Formula")
      ).build(context) as PreferredSizeWidget,
      drawer: new MyNavDrawer(context),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          new Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(5.0),
            child: new Text("Blah"),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              new ButtonBar(children: <Widget>[
                new FlatButton(child: const Text("1"),
                onPressed:(){
                  print("Yo");
                },),
                new FlatButton(child: const Text("2"),
                onPressed:(){
                  print("Yo");
                }),
                new FlatButton(child: const Text("3"),
                onPressed:(){
                  print("Yo");
                })
              ],
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,)
            ],
          )
        ]
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Transform.rotate(
          angle: 45.0,
          child: const Icon(Icons.casino)
        ),
        onPressed: (){
          print("Blah Blah");
        }
      ),
    );
  }
}