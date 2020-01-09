import 'package:customdiceroller/UI/Common.dart';
import 'package:customdiceroller/CDR.dart';
import 'package:customdiceroller/CustVars/Widgets/Label.dart';
import 'package:customdiceroller/Dice/Dice.dart';

import 'package:flutter/material.dart';

class DieEdit extends StatelessWidget{
  final CDR cdr;
  final Die die;
  DieEdit(this.cdr,this.die);
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new MyAppBar(
        title: new Label("Dice")
      ).build(context),
      drawer: new MyNavDrawer(context),
      body: new Center(
        child: new DieEditWidget(die),
      )
    );
  }
}

class DieEditWidget extends StatefulWidget{
  final Die die;

  DieEditWidget(this.die);

  State<DieEditWidget> createState() => DieEditState(die);
}

class DieEditState extends State<DieEditWidget>{
  Die die;

  DieEditState(this.die);

  Widget build(BuildContext context) => new ListView.builder(
    itemCount: die.sides.length+2,
    itemBuilder: (context, i){
      switch(i){
        case 0:
          return new Card(
            child: InkResponse(
              child: new Column(
                children: <Widget>[
                  new Text("Name:",
                    style: Theme.of(context).textTheme.title
                  ),
                  new Text(die.getName(),
                    style: Theme.of(context).textTheme.title
                  )
                ],
              ),
            onLongPress: (){
              print("Time to rename!");
              //TODO: rename
            },
            highlightShape: BoxShape.rectangle,
          )
        );
        case 1:
          return Center(
            child: new Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: new Text("Sides:",
                style: Theme.of(context).textTheme.title
              )
            )
          );
        default:
          return SideCard(die,i-2,this);
      }
    },
  );
}

class SideCard extends StatefulWidget{
  final Die die;
  final int sideNum;
  final DieEditState des;

  SideCard(this.die, this.sideNum,this.des);

  State createState() => SideCardState(die,sideNum,des);
}

class SideCardState extends State<SideCard>{
  Die die;
  int sideNum;
  DieEditState des;

  SideCardState(this.die,this.sideNum,this.des);

  Widget build(BuildContext context) {
    Widget child;
    if(die.isComplex(sideNum)){
      var side = die.getComplex(sideNum);
      //build complex die stuff
    }else{
      child = new Text(die.getSimple(sideNum).stringSide());
    }
    return new GestureDetector(
      onTap: (){
        //Show editing dialog
      },
      child: new Card(
        child: child
      ),
    );
  }
}